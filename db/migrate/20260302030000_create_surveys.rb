class CreateSurveys < ActiveRecord::Migration[7.1]
  def change
    create_table :surveys do |t|
      t.string :need_app # 'yes', 'no', 'maybe'
      t.text :reason
      t.string :contact_info
      t.string :user_type # 'customer', 'master', 'other'
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end

    add_index :surveys, :need_app
    add_index :surveys, :created_at
  end
end
