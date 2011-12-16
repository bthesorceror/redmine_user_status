require_dependency 'principal'
require_dependency 'user'

module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      has_many :user_statuses
      
      named_scope :all_with_statuses, :conditions => {:type => 'User', :status => 1}, 
                                      :order => "lastname, firstname DESC",
                                      :include => :user_statuses
      
    end
  end

  def ClassMethods

  end

  module InstanceMethods

    def create_status_from_issue(issue_id)
      issue = Issue.find(issue_id)
      if issue
        status = UserStatus.new
        status.status = "I am currently working on ##{issue.id}"
        status.user = self
      end
      return status
    end

    def has_user_status_group?
      status_groups = (Setting.plugin_redmine_user_status['user_status_groups'] || []).collect{|g| g.to_i}
      user_groups = self.groups.collect{|g| g.id}
      self.admin? || status_groups.empty? || !(status_groups & user_groups).empty?
    end

    def last_update
      expiry = Setting.plugin_redmine_user_status['user_status_expiry'].to_i
      if expiry && expiry != 0
        self.user_statuses.first :conditions => ["created_at > ?", expiry.days.ago], :order => "created_at desc"
      else
        self.user_statuses.first :order => "created_at desc"
      end
    end
  end
end

