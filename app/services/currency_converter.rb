class CurrencyConversionError < StandardError ; end

class CurrencyConverter
  def self.validate_currency(currency)
    currency =~ /^[A-Z]{3}$/
  end

  def initialize(target_currency)
    @target_currency = target_currency

    currency_converter_url = Rails.application.config.currency_converter_url

    response = HTTParty.get("#{currency_converter_url}/#{target_currency}")

    if !response.success?
      raise CurrencyConversionError.new("Error fetching conversion rates for #{target_currency}")
    end

    @conversion_rates = response["conversion_rates"]
  end

  def convert(amount, currency)
    return amount if currency == @target_currency

    conversion_rate = @conversion_rates[currency]

    if !conversion_rate
      raise CurrencyConversionError.new("Can't retrieve conversion rate for #{currency}")
    end

    amount * conversion_rate
  end
end
