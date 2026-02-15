class AddPreparedByMasterToInsuranceClaims < ActiveRecord::Migration[7.1]
  def change
    add_reference :insurance_claims, :prepared_by_master, foreign_key: { to_table: :users }, index: true
    add_column :insurance_claims, :customer_reviewed, :boolean, default: false
    add_column :insurance_claims, :customer_review_notes, :text
    add_column :insurance_claims, :customer_reviewed_at, :datetime
  end
end
