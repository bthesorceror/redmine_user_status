class UserStatusController < ApplicationController
  unloadable

  before_filter :require_logged, :except => :show_feed
  before_filter :require_key, :only => :show_feed
  before_filter :create_blank_status, :only => [:live_feed, :index, :historic]
  
  accept_key_auth :show_feed

  def index
    @users = User.all_with_statuses
  end

  def create
    @status = UserStatus.create(params[:user_status])
    @status.user = @current_user
    if @status.save
      flash[:notice] = "Status saved"
    else
      flash[:error] = "Could not save update!"
    end
		redirect_to(request.referer)
  end

  def show_history
    @user = User.find(params[:user_id])
    @statuses = UserStatus.user_history(@user.id)                           
    unless @user
      flash[:error] = "Could not find user!"
      redirect_to :action => 'index'
    end
  end

  def show_feed
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
    @statuses = UserStatus.history
    render :layout => false
  end

  def historic
    @statuses = UserStatus.history
  end

	def live_feed
	  unless params[:format] == "js" 
	    @statuses = UserStatus.history
	    session[:last_status_id] = @statuses.size > 0 ? @statuses.first.id : 0
	  else
	    @statuses = UserStatus.more_recent_than(session[:last_status_id])
	    session[:last_status_id] = @statuses.size > 0 ? @statuses.first.id : session[:last_status_id]
	    render :template => "user_status/live_feed_js", :layout => false
	  end
	end
 
  private

  def create_blank_status
    @status = UserStatus.new
  end

  def require_logged
    @current_user = User.current
    unless @current_user.logged?
      redirect_to root_path
    end
  end

  def require_key
    @current_user = User.find_by_rss_key(params[:key]) if params[:key]
    unless @current_user
      render :inline => 'Invalid Key'
      return false
    end
  end

end
