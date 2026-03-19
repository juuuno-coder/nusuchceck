class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    if @query.length >= 2
      @posts   = Post.where("title ILIKE :q OR content ILIKE :q", q: "%#{@query}%").order(created_at: :desc).limit(5)
      @masters = Master.joins(:master_profile)
                       .where("users.name ILIKE :q OR master_profiles.introduction ILIKE :q", q: "%#{@query}%")
                       .includes(:master_profile).limit(5)
    else
      @posts   = Post.none
      @masters = Master.none
    end
  end
end
