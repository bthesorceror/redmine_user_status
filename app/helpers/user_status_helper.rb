module UserStatusHelper

  def last_update(user)
    @status = UserStatus.find(:first, 
                    :conditions => {:user_id => user.id}, 
                    :order => "created_at desc")
    if @status
      render :partial => 'status', :locals => {:status => @status}
    else
      "<br />No status found!"
    end
  end

end
