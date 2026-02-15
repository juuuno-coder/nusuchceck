class Api::StandardEstimateItemsController < ApiController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    items = StandardEstimateItem.active.sorted

    if params[:symptom_type].present?
      items = items.for_symptom(params[:symptom_type])
    end

    if params[:category].present?
      items = items.by_category(params[:category])
    end

    render json: items.map { |item|
      {
        id: item.id,
        category: item.category,
        category_label: item.category_label,
        name: item.name,
        description: item.description,
        unit: item.unit,
        min_price: item.min_price,
        max_price: item.max_price,
        default_price: item.default_price
      }
    }
  end
end
