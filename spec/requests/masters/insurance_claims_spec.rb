require 'rails_helper'

RSpec.describe "Masters::InsuranceClaims", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/masters/insurance_claims/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/masters/insurance_claims/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/masters/insurance_claims/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/masters/insurance_claims/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/masters/insurance_claims/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/masters/insurance_claims/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /send_to_customer" do
    it "returns http success" do
      get "/masters/insurance_claims/send_to_customer"
      expect(response).to have_http_status(:success)
    end
  end

end
