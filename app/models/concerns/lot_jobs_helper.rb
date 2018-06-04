# frozen_string_literal: true

module LotJobsHelper
  extend ActiveSupport::Concern

  def create_status_job! (status)
    job = create_status_job status
    if status == :in_process
      update_column(:lot_jid_in_process, job)
    elsif status == :closed
      update_column(:lot_jid_closed, job)
    end
  end


  def create_status_job (status)
    if status == :in_process
      LotStatusUpdateWorker.perform_at(lot_start_time, id, status)
    elsif status == :closed
      LotStatusUpdateWorker.perform_at(lot_end_time, id, status)
    end
  end

  def create_jobs!
    to_in_process_job = create_status_job :in_process
    to_close_job = create_status_job :closed
    update_columns(lot_jid_in_process: to_in_process_job, lot_jid_closed: to_close_job)
  end
end
