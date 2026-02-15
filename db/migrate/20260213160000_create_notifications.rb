class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.references :actor, polymorphic: true
      t.references :notifiable, polymorphic: true
      t.string :action, null: false
      t.text :message
      t.datetime :read_at
      t.timestamps
    end

    add_index :notifications, [:recipient_type, :recipient_id, :read_at]
    add_index :notifications, [:recipient_type, :recipient_id, :created_at]
  end
end
