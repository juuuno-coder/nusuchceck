class AddPortfolioUrlToExpertInquiries < ActiveRecord::Migration[7.1]
  def change
    add_column :expert_inquiries, :portfolio_url, :string
  end
end
