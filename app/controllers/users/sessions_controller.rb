class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    elsif resource.master?
      masters_requests_path
    else
      customers_requests_path
    end
  end
end
