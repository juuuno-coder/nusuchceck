class AddSpecialtyTypesToMasterProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :master_profiles, :specialty_types, :text, array: true, default: []
    add_index :master_profiles, :specialty_types, using: :gin
  end
end
