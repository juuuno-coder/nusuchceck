class AddAvailabilityToMasterProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :master_profiles, :availability, :string, default: "available", null: false
    add_column :master_profiles, :away_until, :date
    add_column :master_profiles, :away_message, :string
  end
end
