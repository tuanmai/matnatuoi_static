class GoogleConfig < ActiveRecord::Base
  def scope
    [
      'https://www.googleapis.com/auth/drive',
      'https://spreadsheets.google.com/feeds/'
    ]
  end

  def scope=
    [
      'https://www.googleapis.com/auth/drive',
      'https://spreadsheets.google.com/feeds/'
    ]
  end
end
