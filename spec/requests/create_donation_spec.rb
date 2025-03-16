require "rails_helper"

RSpec.describe "POST /api/v1/donations", type: :request do
  let!(:user) { User.create!(api_token: SecureRandom.hex(20)) }
  let(:headers) { { "Authorization" => user.api_token, "Content-Type" => "application/json" } }

  it "creates a donation" do
    params = { donation: { amount: 100, currency: "USD", project_id: 1 } }.to_json

    post "/api/v1/donations", params: params, headers: headers

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["donation"]).to include(
      "amount" => "100.0",
      "currency" => "USD",
      "project_id" => 1,
      "user_id" => user.id
    )
  end

  context "with invalid parameters" do
    it "returns an error" do
      params = { donation: { amount: nil, currency: "USD", project_id: 1 } }.to_json

      post "/api/v1/donations", params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Amount can't be blank")
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
