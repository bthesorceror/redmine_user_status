module UserStatusPlugin
	class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom,
              :partial => 'hooks/user_status/issues_status_link'
  end
end