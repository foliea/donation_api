module AuthenticateApiToken
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    token = request.headers["Authorization"]

    @current_user = User.find_by(api_token: token)

    render json: { error: "Unauthorized" }, status: :unauthorized if !@current_user
  end
end
