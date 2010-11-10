class AddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :user_statuses, :created_at, :datetime
    add_column :user_statuses, :updated_at, :datetime
  end

  def self.down
    remove_column :user_statuses, :created_at
    remove_column :user_statuses, :updated_at
  end
end
