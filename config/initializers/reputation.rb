# Loads the reputation settings file

class ReputationValues < Settingslogic
  source "#{Rails.root}/config/reputation.yml"
end