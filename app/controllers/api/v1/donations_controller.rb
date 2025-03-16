class Api::V1::DonationsController < ApplicationController
  include AuthenticateApiToken

  def post
    render json: {}
  end
end
