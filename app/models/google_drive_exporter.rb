class GoogleDriveExporter
  attr_accessor :session
  @@instance = GoogleDriveExporter.new

  private_class_method :new

  def self.instance(google_config = nil)
    google_config ||= GoogleConfig.last
    if ENV['google_drive_client_key']
      google_config ||= GoogleConfig.create(client_secret: ENV['google_drive_client_secret'], client_id: ENV['google_drive_client_key'])
    end

    raise 'Please add google config' if google_config.blank?

    session = GoogleDrive.saved_session(google_config)
    @@instance.session = session
    @@instance
  end

  def sheet_file(file_name = nil)
    file_name ||= ENV['mat_na_tuoi_sheet_file']
    @sheet_file ||= self.session.file_by_title(file_name)
  end
end
