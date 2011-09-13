class UserStatusController < ApplicationController
  unloadable

  before_filter :require_logged, :except => :show_feed
  before_filter :require_key, :only => :show_feed

  accept_key_auth :show_feed

  def index
    @status = UserStatus.new
    @users = User.all :conditions => {:type => 'User'}, 
                      :order => "lastname, firstname DESC",
                      :include => :user_statuses
  end

  def create
    @status = UserStatus.create(params[:user_status])
    @status.user = @current_user
    @status.created_at = Time.now
    @status.updated_at = Time.now
    if @status.save
      flash[:notice] = l(:l_flash_status_saved)
    else
      flash[:error] = l(:l_flash_could_not_save_update)
    end
		if params[:mode] == "live"
		  redirect_to :action => "live_feed"
		else
    	          redirect_to :action => 'index'
		end
  end

  def show_history
    @user = User.find :first, :conditions => {:id => params[:user_id]}
    @statuses = UserStatus.find :all, 
                                :conditions => {:user_id => @user.id}, 
                                :order => "created_at desc",
                                :include => :user
                                rescue ""
    unless @user
      flash[:error] = l(:l_flash_could_not_find_user)
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
	    @status = UserStatus.new
	    @statuses = UserStatus.history
	    session[:last_status_check] = @statuses.first.created_at if @statuses.size > 0
	  else
	    @old_time = session[:last_status_check]
	    @statuses = UserStatus.all :conditions => ["created_at > ?", @old_time],
	    						   :order => "created_at DESC"
	    session[:last_status_check] = @statuses.first.created_at if @statuses.size > 0
	    render :template => "user_status/live_feed_js", :layout => false
	  end
	end
 
  private

  def require_logged
    @current_user = User.current
    unless @current_user.logged?
      redirect_to root_path
    end
  end

  def require_key
    @key = params[:key]
    unless @key && User.find_by_rss_key(@key)
      render :inline => 'Invalid Key'
      return false
    end
  end

end
