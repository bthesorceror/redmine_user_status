ActionController::Routing::Routes.draw do |map|

  map.connect 'user_status/show_feed.:format', :controller => "user_status", :action => "show_feed"

end
