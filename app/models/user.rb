class User < ApplicationRecord
  has_many :donations

  validates :api_token, presence: true, uniqueness: true
end
