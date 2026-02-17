class AddEscrowTypeToEscrowTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :escrow_transactions, :escrow_type, :string, default: "construction", null: false

    # 기존 단일 uniqueness 제거
    remove_index :escrow_transactions, :request_id

    # (request_id, escrow_type) 복합 유니크 인덱스로 교체
    add_index :escrow_transactions, [:request_id, :escrow_type], unique: true
  end
end
