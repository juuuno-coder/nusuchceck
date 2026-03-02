class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :category
      t.text :message
      t.string :status, default: 'pending'
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end

    add_index :feedbacks, :status
    add_index :feedbacks, :created_at
  end
end
