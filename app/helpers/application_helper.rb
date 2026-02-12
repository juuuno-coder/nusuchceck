module ApplicationHelper
  def status_color(status)
    case status.to_s
    when "reported" then "blue"
    when "assigned" then "yellow"
    when "visiting" then "indigo"
    when "detecting" then "orange"
    when "no_leak_found" then "gray"
    when "estimate_pending", "estimate_submitted" then "purple"
    when "construction_agreed", "escrow_deposited" then "cyan"
    when "constructing" then "violet"
    when "construction_completed" then "teal"
    when "closed" then "green"
    when "cancelled" then "red"
    else "gray"
    end
  end

  def status_badge_classes(status)
    color = status_color(status)
    "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-#{color}-100 text-#{color}-800"
  end

  def format_currency(amount)
    number_to_currency(amount.to_i, unit: "₩", precision: 0)
  end

  def format_date(date)
    date&.strftime("%Y-%m-%d") || "-"
  end

  def format_datetime(datetime)
    datetime&.strftime("%Y-%m-%d %H:%M") || "-"
  end
end
