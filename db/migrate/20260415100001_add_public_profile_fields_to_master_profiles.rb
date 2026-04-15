class AddPublicProfileFieldsToMasterProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :master_profiles, :tagline, :string
    add_column :master_profiles, :intro_video_url, :string
    add_column :master_profiles, :certifications, :text, array: true, default: []
    add_column :master_profiles, :profile_review_status, :string, default: "pending"  # pending / approved / flagged
    add_column :master_profiles, :profile_reviewed_at, :datetime
    add_column :master_profiles, :profile_review_notes, :text
  end
end
