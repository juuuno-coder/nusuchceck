class SubdomainConstraint
  def initialize(subdomain)
    @subdomain = subdomain
  end

  def matches?(request)
    request.subdomain.present? && request.subdomain == @subdomain
  end
end

class NoSubdomainConstraint
  def matches?(request)
    request.subdomain.blank? || request.subdomain == "www"
  end
end
