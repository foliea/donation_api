class User < ApplicationRecord
  validates :api_token, uniqueness: true
end
