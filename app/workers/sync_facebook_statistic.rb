class SyncFacebookStatistic
  include SuckerPunch::Job

  def perform(week_id)
    Sync::FacebookStatistic.new(week_id).call
  end
end
