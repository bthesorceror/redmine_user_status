require 'redmine' 
# require 'redcloth' # gem install RedCloth

require 'dispatcher'
require 'user_patch'
require 'principal_patch'
Dispatcher.to_prepare do
  Principal.send(:include, PrincipalPatch) unless Principal.included_modules.include? PrincipalPatch
  User.send(:include, UserPatch) unless User.included_modules.include? UserPatch
end

Redmine::Plugin.register :redmine_user_status do
  name 'Redmine User Status plugin'
  author 'Brandon Farmer'
  description 'Allows you to find out what co workers are doing'
  version '0.0.2'
 
  settings :default => {'user_status_expiry' => ''}, :partial => 'settings/user_status_settings'
  settings :default => {'user_status_limit' => 100}, :partial => 'settings/user_status_settings'

  permission :feed_view, {:user_status => [:show_feed]}, :public => true
  menu :top_menu, :user_status, {:controller => 'user_status', :action => 'index'}, :caption => :top_menu_caption, :if => Proc.new { User.current.logged? }

end

