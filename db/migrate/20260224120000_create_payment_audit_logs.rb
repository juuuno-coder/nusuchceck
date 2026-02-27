class CreatePaymentAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_audit_logs do |t|
      t.references :escrow_transaction, foreign_key: true, null: true
      t.references :user, foreign_key: true, null: true
      t.string :action, null: false  # attempt, success, fail, refund, cancel, webhook_received
      t.jsonb :details, default: {}  # request params, response data, error message 등
      t.string :ip_address          # 결제 시도한 IP 주소

      t.timestamps
    end

    add_index :payment_audit_logs, :action
    add_index :payment_audit_logs, :created_at
    add_index :payment_audit_logs, [:user_id, :created_at]
  end
end
