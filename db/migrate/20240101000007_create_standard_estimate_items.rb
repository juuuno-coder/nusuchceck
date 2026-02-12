# frozen_string_literal: true

class CreateStandardEstimateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :standard_estimate_items do |t|
      t.string  :category, null: false
      t.string  :name,     null: false
      t.text    :description
      t.string  :unit

      t.decimal :min_price,     precision: 10, scale: 2
      t.decimal :max_price,     precision: 10, scale: 2
      t.decimal :default_price, precision: 10, scale: 2

      t.text    :recommended_for, array: true, default: []
      t.integer :sort_order, default: 0
      t.boolean :active,     default: true

      t.timestamps
    end
  end
end
