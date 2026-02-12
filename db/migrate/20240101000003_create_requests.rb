# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }, index: true
      t.references :master,   null: true,  foreign_key: { to_table: :users }, index: true

      t.string  :status,       default: "reported", index: true
      t.integer :symptom_type, null: false
      t.integer :building_type, default: 0

      # Location
      t.text    :address,          null: false
      t.string  :detailed_address
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string  :floor_info

      t.text     :description
      t.datetime :preferred_date

      # Workflow timestamps
      t.datetime :assigned_at
      t.datetime :visit_started_at
      t.datetime :detection_started_at
      t.datetime :construction_started_at
      t.datetime :construction_completed_at
      t.datetime :closed_at

      # Detection
      t.integer :detection_result
      t.text    :detection_notes

      # Fees
      t.decimal :trip_fee,         precision: 10, scale: 2, default: 0
      t.decimal :detection_fee,    precision: 10, scale: 2, default: 0
      t.decimal :construction_fee, precision: 10, scale: 2, default: 0
      t.decimal :total_fee,        precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
