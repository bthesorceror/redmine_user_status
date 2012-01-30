module UserStatusHelper

  def last_update(user)
    @status = UserStatus.last_update
    if @status
      render :partial => 'status', :locals => {:status => @status}
    else
      content_tag(:p, "No status found!")
    end
  end
  
  def timeago(time)
    content_tag(:abbr, time, :title => time.getutc.iso8601, :class => "timeago")
  end
  
  def link_if_not_history(user)
    if controller.action_name != "show_history"
      link_to(user.name, {:action => :show_history, :user_id => user.id}) 
    else
      user.name
    end
  end

  def delete_link(status)
    if status.has_delete_rights?(User.current)
      content_tag :small do
        link_to("Delete", {:controller => :user_status, :action => :destroy, :id => status.id}, 
              :method => :delete, :style => "color: red;")
      end
    end
  end

end
