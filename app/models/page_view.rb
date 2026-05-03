class PageView < ApplicationRecord
  validates :viewed_on, :path, presence: true

  scope :recent_days, ->(n) { where("viewed_on >= ?", n.days.ago.to_date) }

  # 날짜별 총 PV
  def self.daily_counts(days = 14)
    recent_days(days)
      .group(:viewed_on)
      .order(:viewed_on)
      .count
  end

  # 날짜별 상위 경로
  def self.top_paths_per_day(days = 14, limit = 5)
    recent_days(days)
      .group(:viewed_on, :path)
      .order(:viewed_on, "count_all DESC")
      .count
  end

  # 일자별 인기 경로 top N
  def self.top_paths(days = 14, limit = 10)
    recent_days(days)
      .group(:path)
      .order("count_all DESC")
      .limit(limit)
      .count
  end
end
