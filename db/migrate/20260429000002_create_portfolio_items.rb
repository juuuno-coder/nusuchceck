class CreatePortfolioItems < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_items do |t|
      t.references :master_profile, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :source, default: "upload"  # upload / instagram
      t.string :external_url              # 인스타 permalink 등
      t.string :image_url                 # 외부 이미지 URL (인스타)
      t.boolean :pinned, default: false
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :portfolio_items, [:master_profile_id, :position]
  end
end
