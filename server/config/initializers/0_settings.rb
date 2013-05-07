class Settings < Settingslogic
  source "#{Rails.root}/config/diors.yml"
  namespace Rails.env
end
