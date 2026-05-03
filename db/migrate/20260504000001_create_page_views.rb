class CreatePageViews < ActiveRecord::Migration[7.1]
  def change
    create_table :page_views do |t|
      t.date    :viewed_on,  null: false
      t.string  :path,       null: false, limit: 255
      t.string  :controller_name, limit: 100
      t.string  :action_name,     limit: 100
      t.integer :user_id
      t.timestamps
    end

    add_index :page_views, :viewed_on
    add_index :page_views, [:viewed_on, :path]
  end
end
