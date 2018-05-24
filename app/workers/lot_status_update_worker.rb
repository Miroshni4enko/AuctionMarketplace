# frozen_string_literal: true

class LotStatusUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(lot_id)
    lot = Lot.find lot_id
    lot.update(status: :in_process)
  end
end
