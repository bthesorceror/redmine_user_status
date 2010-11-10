class UserStatus < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :status
end

class User < Principal
  has_many :user_statuses, :class_name => 'UserStatus'

  attr_accessible :user_statuses

end
