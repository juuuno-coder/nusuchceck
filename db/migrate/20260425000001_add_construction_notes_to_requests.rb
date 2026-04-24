class AddConstructionNotesToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :construction_notes, :text
    add_column :requests, :construction_photos_count, :integer, default: 0
  end
end
