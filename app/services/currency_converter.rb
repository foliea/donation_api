class CurrencyConversionError < StandardError ; end

class CurrencyConverter
  VALID_CURRENCIES = %w[
    AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BRL BSD BTN BWP BYN BZD CAD CDF
    CHF CLP CNY COP CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP FOK GBP GEL GGP GHS GIP GMD GNF GTQ
    GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR KID KMF KRW KWD KYD KZT LAK
    LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB
    PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STN SYP SZL THB TJS
    TMT TND TOP TRY TTD TVD TWD TZS UAH UGX USD UYU UZS VES VND VUV WST XAF XCD XDR XOF XPF YER ZAR ZMW ZWL
  ].freeze

  def self.valid?(currency)
    VALID_CURRENCIES.include?(currency)
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

    amount / conversion_rate
  end
end
