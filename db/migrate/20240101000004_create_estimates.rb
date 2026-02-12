# frozen_string_literal: true

class CreateEstimates < ActiveRecord::Migration[7.1]
  def change
    create_table :estimates do |t|
      t.references :request, null: false, foreign_key: true, index: true
      t.references :master,  null: false, foreign_key: { to_table: :users }, index: true

      t.jsonb :line_items, default: []

      # Subtotals
      t.decimal :detection_subtotal,    precision: 10, scale: 2, default: 0
      t.decimal :construction_subtotal, precision: 10, scale: 2, default: 0
      t.decimal :material_subtotal,     precision: 10, scale: 2, default: 0
      t.decimal :vat,                   precision: 10, scale: 2, default: 0
      t.decimal :total_amount,          precision: 10, scale: 2, default: 0

      t.string   :status, default: "pending"
      t.text     :notes
      t.datetime :valid_until
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
