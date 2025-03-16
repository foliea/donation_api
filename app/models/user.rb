class User < ApplicationRecord
  validates :api_token, presence: true, uniqueness: true
end
