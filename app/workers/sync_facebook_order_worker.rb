class SyncFacebookOrderWorker
  include Sidekiq::Worker

  def perform(week_id)
    week = Week.find(week_id)
    Sync::FacebookCustomer.new.call
    Sync::FacebookOrder.new(week).call
  end
end
