class CreateMasterApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :master_applications do |t|
      t.references :request, null: false, foreign_key: true
      t.references :master, null: false, foreign_key: { to_table: :users }
      t.text :intro_message
      t.integer :status, default: 0, null: false  # 0: pending, 1: selected, 2: rejected

      t.timestamps
    end

    add_index :master_applications, [:request_id, :master_id], unique: true
  end
end
