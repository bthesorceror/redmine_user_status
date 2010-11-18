class UserStatus < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :status

  def self.history
    limit = Setting.plugin_redmine_user_status['user_status_limit'].to_i
    if limit && limit != 0
      @statuses = UserStatus.all  :order => "created_at desc", 
                                  :include => :user, 
                                  :limit => limit
    else
      @statuses = UserStatus.all  :order => "created_at desc", 
                                  :include => :user, 
                                  :limit => 100
    end
  end
end


