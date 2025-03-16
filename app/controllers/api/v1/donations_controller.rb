class Api::V1::DonationsController < ApplicationController
  include AuthenticateApiToken

  def create
    donation = @current_user.donations.build(donation_params)

    if !donation.save
      return render json: { errors: donation.errors.full_messages }, status: :unprocessable_entity
    end

    render json: { donation: donation }, status: :created
  end

  private

  def donation_params
    params.require(:donation).permit(:amount, :currency, :project_id)
  end
end
