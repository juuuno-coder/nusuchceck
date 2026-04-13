class AddBillingFieldsToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :billing_key, :string
    add_column :subscriptions, :customer_key, :string
    add_column :subscriptions, :next_billing_at, :datetime
    add_column :subscriptions, :billing_status, :string, default: "none"
    # billing_status: none, active, failed, cancelled

    add_index :subscriptions, :billing_key
    add_index :subscriptions, :customer_key
  end
end
