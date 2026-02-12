class EstimateCalculator
  # 증상별 추천 견적 항목 매핑
  SYMPTOM_RECOMMENDATIONS = {
    wall_leak: %w[trip detection construction material],
    ceiling_leak: %w[trip detection construction material],
    floor_leak: %w[trip detection construction material],
    pipe_leak: %w[trip detection construction material],
    toilet_leak: %w[trip detection construction material],
    outdoor_leak: %w[trip detection construction material]
  }.freeze

  attr_reader :request

  def initialize(request)
    @request = request
  end

  # 증상에 따른 추천 항목 반환
  def recommended_items
    StandardEstimateItem.active.for_symptom(request.symptom_type).sorted
  end

  # 전체 표준 항목 (카테고리별)
  def all_items_by_category
    StandardEstimateItem.active.sorted.group_by(&:category)
  end

  # 가격대 조회
  def price_range
    items = recommended_items
    return { min: 0, max: 0, estimated: 0 } if items.empty?

    {
      min: items.sum(&:min_price).to_i,
      max: items.sum(&:max_price).to_i,
      estimated: items.sum(&:default_price).to_i
    }
  end

  # 추천 견적 라인 아이템 자동 생성
  def generate_recommended_line_items
    recommended_items.map do |item|
      item.to_line_item(quantity: 1)
    end
  end

  # 견적서 총액 계산
  def calculate_total(line_items)
    subtotal = line_items.sum { |item| item[:amount].to_d }
    vat = (subtotal * 0.1).round(2)
    {
      subtotal: subtotal,
      vat: vat,
      total: subtotal + vat
    }
  end

  # 카테고리별 소계
  def subtotals_by_category(line_items)
    grouped = line_items.group_by { |item| item[:category] }
    {
      trip: grouped.fetch("trip", []).sum { |i| i[:amount].to_d },
      detection: grouped.fetch("detection", []).sum { |i| i[:amount].to_d },
      construction: grouped.fetch("construction", []).sum { |i| i[:amount].to_d },
      material: grouped.fetch("material", []).sum { |i| i[:amount].to_d }
    }
  end
end
