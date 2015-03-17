# Loads the site settings file

class SiteSettings < Settingslogic
  source "#{Rails.root}/config/site_settings.yml"
end
