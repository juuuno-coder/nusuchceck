# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :request,  null: false, foreign_key: true, index: { unique: true }
      t.references :customer, null: false, foreign_key: { to_table: :users }, index: true
      t.references :master,   null: false, foreign_key: { to_table: :users }, index: true

      t.decimal :overall_rating,     precision: 3, scale: 2, null: false
      t.integer :punctuality_rating
      t.integer :skill_rating
      t.integer :kindness_rating
      t.integer :cleanliness_rating
      t.integer :price_rating

      t.text :comment

      t.timestamps
    end
  end
end
