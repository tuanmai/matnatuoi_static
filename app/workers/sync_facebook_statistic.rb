class SyncFacebookStatistic
  include Sidekiq::Worker

  def perform(week_id)
    Sync::FacebookStatistic.new(week_id).call
  end
end
