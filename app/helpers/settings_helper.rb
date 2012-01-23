module SettingsHelper
  def selected_groups 
    (Setting.plugin_redmine_user_status['user_status_groups'] || []).collect{|g| g.to_i}
  end
end