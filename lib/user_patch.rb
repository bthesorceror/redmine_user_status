require_dependency 'principal'
require_dependency 'user'

module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      has_many :user_statuses
    end
  end

  def ClassMethods

  end

  module InstanceMethods
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

