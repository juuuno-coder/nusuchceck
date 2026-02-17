class AddWarrantyToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :warranty_period_months, :integer, default: 0
    add_column :requests, :warranty_expires_at, :datetime
    add_column :requests, :warranty_notes, :text

    # CS용 고객 문의 필드
    add_column :requests, :customer_complaint, :text
    add_column :requests, :complaint_submitted_at, :datetime
  end
end
