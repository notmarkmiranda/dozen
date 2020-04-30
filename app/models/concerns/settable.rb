module Settable
  extend ActiveSupport::Concern

  included do
    has_many :settings, as: :settable

    def add_all_settings
      setting_type = self.class.to_s.downcase.to_sym
      all_settings = Setting::ALL_SETTINGS[setting_type]

      all_settings.each do |setting|
        set = self.settings.find_or_initialize_by(name: setting[:name])
        set.assign_attributes(setting) if set.new_record?
        set.save!
      end
    end  
      
    def decorated_settings
      settings.decorate
    end
  end
end