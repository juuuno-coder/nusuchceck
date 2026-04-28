class AddPublicTokenAndLinksToMasterProfiles < ActiveRecord::Migration[7.1]
  def change
    # 전문가 URL 토큰
    add_column :master_profiles, :public_token, :string
    add_index :master_profiles, :public_token, unique: true

    # 커스텀 링크 (JSON 배열)
    add_column :master_profiles, :custom_links, :jsonb, default: []

    # 인스타그램 연동
    add_column :master_profiles, :instagram_username, :string
    add_column :master_profiles, :instagram_access_token, :string
    add_column :master_profiles, :instagram_posts, :jsonb, default: []
    add_column :master_profiles, :instagram_synced_at, :datetime

    # 기존 레코드에 토큰 부여
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE master_profiles SET public_token = substr(md5(random()::text || user_id::text), 1, 10) WHERE public_token IS NULL
        SQL
      end
    end
  end
end
