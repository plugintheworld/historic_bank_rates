require 'date'
require_relative 'bank_scrapers/central_bank_of_kenya'
require_relative 'bank_scrapers/bank_of_tanzania'

module HistoricBankRates
  class Rates
    attr_reader :start_date
    attr_accessor :rate_scraper

    def initialize rate_scraper, start_date=nil
      @rate_scraper = rate_scraper
      @start_date = start_date || date_yesterday
    end

    def rate(iso_from, iso_to)
      fail_unless_rates_present

      if iso_from == rate_scraper_base_currency
        rates[iso_to] ? 1/rates[iso_to] : nil
      elsif iso_to == rate_scraper_base_currency
        rates[iso_from]
      else
        nil
      end
    end

    # Returns a list of ISO currencies
    def currencies
      fail_unless_rates_present
      @rates.keys
    end

    # Returns all rates imported
    def rates
      fail_unless_rates_present
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      !@rates.nil? && !@rates.empty?
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

    def rate_scraper_base_currency
      rate_scraper.base_currency
    end

    def fail_unless_rates_present
      fail MissingRates unless has_rates?
    end
  end
end
