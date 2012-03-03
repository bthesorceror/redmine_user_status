ActionController::Routing::Routes.draw do |map|

  map.connect 'user_status/show_feed.:format', :controller => "user_status", :action => "show_feed"
  map.resources :user_status, :collection => {
    :historic => :get,
    :create_from_issue => :post,
    :show_history => :get,
    :live_feed => :get
  }

end
