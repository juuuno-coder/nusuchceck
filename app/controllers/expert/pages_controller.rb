class Expert::PagesController < Expert::BaseController
  skip_before_action :authenticate_user!

  def index
  end
end
