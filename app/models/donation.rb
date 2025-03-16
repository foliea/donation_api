class Donation < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :project_id, presence: true
end
