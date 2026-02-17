class AddTossFieldsToEscrowTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :escrow_transactions, :toss_order_id, :string
    add_column :escrow_transactions, :toss_payment_key, :string
    add_index :escrow_transactions, :toss_order_id,
              unique: true, where: "toss_order_id IS NOT NULL"
  end
end
