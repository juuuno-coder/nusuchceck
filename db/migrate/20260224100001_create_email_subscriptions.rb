class CreateEmailSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :email_subscriptions do |t|
      t.string :email, null: false
      t.datetime :subscribed_at

      t.timestamps
    end

    add_index :email_subscriptions, :email, unique: true
  end
end
