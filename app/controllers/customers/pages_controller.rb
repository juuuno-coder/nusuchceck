class Customers::PagesController < ApplicationController
  # 비로그인 사용자를 위한 랜딩페이지
  def landing
    # 이미 로그인한 사용자는 대시보드로 리다이렉트
    redirect_to customers_dashboard_path if user_signed_in?
  end
end
