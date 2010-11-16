require 'redmine'
require 'redcloth' # gem install RedCloth
require 'user_patch.rb'

Redmine::Plugin.register :redmine_user_status do
  name 'Redmine User Status plugin'
  author 'Brandon Farmer'
  description 'Allows you to find out what co workers are doing'
  version '0.0.1'
  permission :feed_view, {:user_status => [:show_feed]}, :public => true
  menu :top_menu, :user_status, {:controller => 'user_status', :action => 'index'}, :caption => 'Statuses', :if => Proc.new { User.current.logged? }

end
