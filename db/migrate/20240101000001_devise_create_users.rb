# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      # STI
      t.string :type

      # Devise - Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      # Devise - Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Devise - Rememberable
      t.datetime :remember_created_at

      # Profile
      t.string  :name,      null: false
      t.string  :phone
      t.text    :address
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      # Role
      t.integer :role, default: 0

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :type
  end
end
