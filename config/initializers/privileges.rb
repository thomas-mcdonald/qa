# Sets up the $privileges global, which contains reputation requirements

class ReputationRequirements < Settingslogic
  source "#{Rails.root}/config/privileges.yml"
end