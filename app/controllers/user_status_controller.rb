class UserStatusController < ApplicationController
  unloadable

  before_filter :require_group
  before_filter :create_blank_status,
                :only => [:index, :historic, :live_feed]
  before_filter :require_delete_rights, :only => :destroy

  accept_rss_auth :show_feed

  def index
    @users = User.all_with_statuses
  end

  def create
    @status = @current_user.user_statuses.build(params[:user_status])
    if @status.save
      flash[:notice] = "Status saved"
    else
      flash[:error] = "Could not save update!"
    end
		redirect_to(request.referer)
  end

  def destroy
    @status.destroy
    flash[:notice] = "Status has been deleted"
    redirect_to(request.referer)
  end

  def create_from_issue
    if @current_user.create_status_from_issue(params[:issue_id])
      flash[:notice] = "Status saved"
    else
      flash[:eror] = "Could not save update!"
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

  def require_group
    @current_user = User.current
    unless @current_user.logged? && @current_user.has_user_status_group?
      flash[:error] = "You are not authorized."
      redirect_to root_path
    end
  end

  def require_delete_rights
    @status = UserStatus.find(params[:id])
    unless @status && @status.has_delete_rights?(User.current)
      flash[:error] = "You cannot delete this status"
      redirect_to root_path
    end 
  end

end
