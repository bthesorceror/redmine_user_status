require 'redmine'
require 'redcloth' # gem install RedCloth
Redmine::Plugin.register :redmine_user_status do
  name 'Redmine User Status plugin'
  author 'Brandon Farmer'
  description 'Allows you to find out what co workers are doing'
  version '0.0.1'

  menu :top_menu, :user_status, {:controller => 'user_status', :action => 'index'}, :caption => 'Statuses', :if => Proc.new { User.current.logged? }

end
