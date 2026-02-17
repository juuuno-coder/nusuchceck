module HotwireNativeApp
  extend ActiveSupport::Concern

  included do
    helper_method :hotwire_native_app?, :native_android?, :native_ios?
  end

  def hotwire_native_app?
    native_android? || native_ios?
  end

  def native_android?
    request.user_agent.to_s.include?("HotwireNative/Android") ||
      request.user_agent.to_s.include?("NusuCheck/Android")
  end

  def native_ios?
    request.user_agent.to_s.include?("HotwireNative/iOS") ||
      request.user_agent.to_s.include?("NusuCheck/iOS")
  end
end
