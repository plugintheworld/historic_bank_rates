require 'date'
require_relative 'bank_scrapers/central_bank_of_kenya'
require_relative 'bank_scrapers/bank_of_tanzania'
require_relative 'bank_scrapers/rwanda_national_bank'

module HistoricBankRates
  class MissingRates < StandardError; end
  class Rates
    attr_reader :start_date
    attr_accessor :rate_scraper

    def initialize rate_scraper, start_date=nil
      @rate_scraper = rate_scraper
      @start_date = start_date || date_yesterday
    end

    def rate(iso_from, iso_to)
      case rate_scraper.base_currency
      when iso_from
        rates[iso_to] ? 1/rates[iso_to] : nil
      when iso_to
        rates[iso_from]
      else
        fail_if_rates_missing
      end
    end

    # Returns a list of ISO currencies
    def currencies
      rates.keys
    end

    # Returns all rates imported
    def rates
      fail_if_rates_missing
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      @rates && @rates.any?
    end

    # Triggers the scraping
    def import! import_date=nil
      @start_date = import_date unless import_date.nil?
      @rates = rate_scraper.call(start_date)
      has_rates?
    end

    private

    def date_yesterday
      Date.today - 1
    end

    def fail_if_rates_missing
      fail MissingRates unless has_rates?
    end
  end
end
