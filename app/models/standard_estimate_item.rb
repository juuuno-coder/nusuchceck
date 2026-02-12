class StandardEstimateItem < ApplicationRecord
  validates :category, presence: true, inclusion: { in: %w[trip detection construction material] }
  validates :name, presence: true
  validates :default_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :by_category, ->(cat) { where(category: cat) }
  scope :sorted, -> { order(sort_order: :asc, name: :asc) }
  scope :for_symptom, ->(symptom) { where("? = ANY(recommended_for)", symptom.to_s) }

  def price_range
    return "가격 미정" unless min_price && max_price
    "#{number_to_currency(min_price)} ~ #{number_to_currency(max_price)}"
  end

  def category_label
    case category
    when "trip" then "출장비"
    when "detection" then "탐지"
    when "construction" then "공사"
    when "material" then "자재"
    else category
    end
  end

  def to_line_item(quantity: 1, price: nil)
    {
      item_id: id,
      category: category,
      name: name,
      unit: unit,
      quantity: quantity,
      unit_price: price || default_price,
      amount: (price || default_price).to_d * quantity
    }
  end

  private

  def number_to_currency(amount)
    ActionController::Base.helpers.number_to_currency(amount, unit: "₩", precision: 0)
  end
end
