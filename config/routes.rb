if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do

    match 'user_status/show_feed.:format',:controller => 'user_status', :action => 'show_feed'
    resources :user_status do
      collection do
        get "historic"
        get "create_from_issue"
        post "create_from_issue"
        get "show_history"
        get "live_feed"
      end
    end
  end
else

  ActionController::Routing::Routes.draw do |map|

    map.connect 'user_status/show_feed.:format', :controller => "user_status", :action => "show_feed"
    map.resources :user_status, :collection => {
        :historic => :get,
        :create_from_issue => [ :get, :post ],
        :show_history => :get,
        :live_feed => :get
    }

  end
end
