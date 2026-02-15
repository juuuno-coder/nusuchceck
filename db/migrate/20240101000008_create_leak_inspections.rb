class CreateLeakInspections < ActiveRecord::Migration[7.1]
  def change
    create_table :leak_inspections do |t|
      t.references :customer, null: true, index: true

      t.string  :status, default: "pending", null: false
      t.boolean :leak_detected, default: false
      t.string  :severity
      t.text    :analysis_summary
      t.jsonb   :analysis_detail, default: {}
      t.text    :recommended_action

      t.string  :location_description
      t.integer :symptom_type

      t.string  :ai_model_used
      t.integer :ai_tokens_used, default: 0
      t.float   :analysis_duration_seconds

      t.string  :session_token, null: false

      t.timestamps
    end

    add_index :leak_inspections, :status
    add_index :leak_inspections, :session_token, unique: true
    add_foreign_key :leak_inspections, :users, column: :customer_id
  end
end
