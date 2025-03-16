class Api::V1::DonationsController < ApplicationController
  include AuthenticateApiToken

  TOTAL_DEFAULT_CURRENCY = "USD"

  def create
    donation = @current_user.donations.build(donation_params)

    if !donation.save
      return render json: { errors: donation.errors.full_messages }, status: :bad_request
    end

    render json: { donation: donation }, status: :created
  end

  def total
    target_currency = params[:currency] || TOTAL_DEFAULT_CURRENCY

    if !CurrencyConverter.valid?(target_currency)
      return render json: { error: "Currency must be ISO 4217." }, status: :bad_request
    end

    user_donations = @current_user.donations

    return render json: { total_amount: 0, currency: target_currency } if user_donations.empty?

    begin
      currency_converter = CurrencyConverter.new(target_currency)

      total_amount = user_donations.sum do |donation|
        currency_converter.convert(donation.amount, donation.currency)
      end

      render json: { total_amount: total_amount.to_f, currency: target_currency }
    rescue CurrencyConversionError => e
      Rails.logger.error(e.message)

      head :internal_server_error
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:amount, :currency, :project_id)
  end
end
