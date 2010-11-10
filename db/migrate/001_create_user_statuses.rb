class CreateUserStatuses < ActiveRecord::Migration
  def self.up
    create_table :user_statuses do |t|
      t.column :user_id, :integer
      t.column :status, :text
    end
  end

  def self.down
    drop_table :user_statuses
  end
end
