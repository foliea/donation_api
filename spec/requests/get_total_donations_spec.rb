require "rails_helper"

RSpec.describe "GET /api/v1/donations/total", type: :request do
  let(:currency_converter_url) { Rails.application.config.currency_converter_url }
  let(:user) { User.create!(api_token: SecureRandom.hex(20)) }
  let(:project) { Project.create!(name: "Charity month") }
  let(:headers) { { "Authorization" => user.api_token, "Content-Type" => "application/json" } }

  it "returns the total amount of donations converted to given currency" do
    Donation.create!(user: user, amount: 100, currency: 'EUR', project_id: project.id)
    Donation.create!(user: user, amount: 50, currency: 'GBP', project_id: project.id)
    Donation.create!(user: user, amount: 200, currency: 'EUR', project_id: project.id)

    stub_request(:get, "#{currency_converter_url}/EUR").to_return(
      status: 200,
      body: { "conversion_rates" => { "EUR" => 1, "GBP" => 0.9 } }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    get "/api/v1/donations/total?currency=EUR", headers: headers

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body)).to eq({ "total_amount" => 345.0, "currency" => "EUR" })
  end

  context 'when another user has donations' do
    before do
      other_user = User.create!(api_token: SecureRandom.hex(20))

      Donation.create!(user: other_user, amount: 100, currency: 'USD', project_id: project.id)
    end

    it "does not include the other user donations" do
      get "/api/v1/donations/total", headers: headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "total_amount" => 0, "currency" => "USD" })
    end
  end

  context "when exchange rate service can not be reached" do
    it "returns an error" do
      Donation.create!(user: user, amount: 200, currency: 'EUR', project_id: project.id)

      stub_request(:get, "#{currency_converter_url}/USD").to_return(
        status: 500,
        body: {}.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      allow(Rails.logger).to receive(:error)

      get "/api/v1/donations/total", headers: headers

      expect(response).to have_http_status(:internal_server_error)
      expect(Rails.logger).to have_received(:error).with("Error fetching conversion rates for USD")
    end
  end

  context "when exchange rate of given currency can not be retrieved" do
    it "returns an error" do
      Donation.create!(user: user, amount: 200, currency: 'EUR', project_id: project.id)

      stub_request(:get, "#{currency_converter_url}/USD").to_return(
        status: 200,
        body: { "conversion_rates" => { "USD" => 1 } }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      allow(Rails.logger).to receive(:error)

      get "/api/v1/donations/total", headers: headers

      expect(response).to have_http_status(:internal_server_error)
      expect(Rails.logger).to have_received(:error).with("Can't retrieve conversion rate for EUR")
    end
  end

  context "when currency is not specified" do
    it "returns the total amount in USD" do
      get "/api/v1/donations/total", headers: headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "total_amount" => 0, "currency" => "USD" })
    end
  end

  context "when currency is invalid" do
    it "returns an error" do
      get "/api/v1/donations/total?currency=toto", headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("Currency must be ISO 4217.")
    end
  end

  context "with invalid currency is not specified" do
    it "returns the total amount in USD" do
      get "/api/v1/donations/total", headers: headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "total_amount" => 0, "currency" => "USD" })
    end
  end

  context "without API token" do
    it "denies access to donations creation" do
      get "/api/v1/donations/total"

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
    end
  end

  context "with invalid API token" do
    it "denies access donations creation" do
      get "/api/v1/donations/total", headers: { "Authorization" => "invalid_token" }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
    end
  end
end
