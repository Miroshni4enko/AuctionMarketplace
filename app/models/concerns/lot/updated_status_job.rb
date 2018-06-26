class Lot
  module UpdatedStatusJob
    extend ActiveSupport::Concern

    included do
      after_commit :create_jobs!, on: :create
      before_update :update_jobs_by_start_and_end_time
    end

    def create_updated_status_job (status, time)
      LotStatusUpdateWorker.perform_at(time, status)
    end

    def create_updated_status_job! (status, time)
      job = create_updated_status_job status, time
      update_column("lot_jid_#{status}", job)
    end

    def create_jobs!
      to_in_process_job = create_updated_status_job :in_process, lot_start_time
      to_close_job = create_updated_status_job :closed, lot_end_time
      update_columns(lot_jid_in_process: to_in_process_job, lot_jid_closed: to_close_job)
    end

    def update_jobs_by_start_and_end_time
      if lot_start_time_changed?
        create_updated_status_job! :in_process, lot_start_time
      end

      if lot_end_time_changed?
        create_updated_status_job! :closed, lot_end_time
      end
    end
  end
end