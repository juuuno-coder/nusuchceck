# frozen_string_literal: true

class CreateEscrowTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :escrow_transactions do |t|
      t.references :request,  null: false, foreign_key: true, index: { unique: true }
      t.references :customer, null: false, foreign_key: { to_table: :users }, index: true
      t.references :master,   null: false, foreign_key: { to_table: :users }, index: true

      t.decimal :amount,        precision: 12, scale: 2, null: false
      t.decimal :platform_fee,  precision: 10, scale: 2, default: 0
      t.decimal :master_payout, precision: 10, scale: 2, default: 0

      t.string :payment_method
      t.string :pg_transaction_id
      t.string :status, default: "pending"

      t.datetime :deposited_at
      t.datetime :released_at
      t.datetime :refunded_at

      t.timestamps
    end
  end
end
