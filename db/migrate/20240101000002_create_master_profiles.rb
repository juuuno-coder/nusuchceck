# frozen_string_literal: true

class CreateMasterProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :master_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.string  :license_number
      t.string  :license_type
      t.jsonb   :equipment,    default: []
      t.text    :service_areas, array: true, default: []
      t.integer :experience_years, default: 0

      # Bank account
      t.string :bank_name
      t.string :account_number
      t.string :account_holder

      # Verification
      t.boolean  :verified,    default: false
      t.datetime :verified_at

      t.text :bio

      t.timestamps
    end
  end
end
