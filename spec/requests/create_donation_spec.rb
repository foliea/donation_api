require "rails_helper"

RSpec.describe "POST /api/v1/donations", type: :request do
  let(:user) { User.create!(api_token: SecureRandom.hex(20)) }
  let(:project) { Project.create!(name: "Charity month") }
  let(:headers) { { "Authorization" => user.api_token, "Content-Type" => "application/json" } }

  it "creates a donation" do
    params = { donation: { amount: 100, currency: "USD", project_id: project.id } }.to_json

    post "/api/v1/donations", params: params, headers: headers

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["donation"]).to include(
      "amount" => "100.0",
      "currency" => "USD",
      "project_id" => project.id,
      "user_id" => user.id
    )
  end

  context "with invalid parameters" do
    it "returns an error" do
      params = { donation: { amount: nil, currency: "USD", project_id: project.id } }.to_json

      post "/api/v1/donations", params: params, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["errors"]).to include("Amount can't be blank")
    end
  end

  context "when project id does not exists" do
    it "returns an error" do
      params = { donation: { amount: 100, currency: "USD", project_id: 42 } }.to_json

      post "/api/v1/donations", params: params, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["errors"]).to include("Project must exist")
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
