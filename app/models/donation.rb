class Donation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true

  validate :currency_is_valid_iso4217?

  private

  def currency_is_valid_iso4217?
    if !CurrencyConverter.validate_currency(currency)
      errors.add(:currency, "must be a valid ISO 4217 currency code")
    end
  end
end
