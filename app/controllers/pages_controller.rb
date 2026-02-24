class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def coming_soon
  end

  def about
  end
end
