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
      self.user_statuses.first :order => "created_at desc"
    end
  end
end

