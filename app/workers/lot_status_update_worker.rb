# frozen_string_literal: true

class LotStatusUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(lot_id, status)
    lot = Lot.find lot_id
    if lot
      if status == :in_process && lot.lot_jid_in_process == jid
        lot.update(status: :in_process)
      elsif status == :closed && lot.lot_jid_closed == jid
        lot.update(status: :update)
      end
    end
  end
end
