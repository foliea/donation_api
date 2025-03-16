require "rails_helper"

RSpec.describe "POST /api/v1/donations", type: :request do
  let!(:user) { User.create!(api_token: SecureRandom.hex(20)) }

  context "with valid API token" do
    it "allows to create a donation" do
      post "/api/v1/donations", headers: { "Authorization" => user.api_token }

      expect(response).to have_http_status(:success)
    end
  end

  context "without API token" do
    it "denies access to donations creation" do
      post "/api/v1/donations"

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
    end
  end

  context "with invalid API token" do
    it "denies access donations creation" do
      post "/api/v1/donations", headers: { "Authorization" => "invalid_token" }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
    end
  end
end
