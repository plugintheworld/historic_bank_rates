require 'nokogiri'
require 'uri'
require 'net/http'

module HistoricBankRates
  class RateScraper
    TRANSLATE = {}

    attr_reader :start_date
    attr_accessor :form_url

    def initialize
    end

    def call start_date
      @start_date = start_date

      rates
    end

    def base_currency
      # Must implement
      raise NotImplementedError
    end

    private

    def rates
      # Must implement
      raise NotImplementedError
    end

    def form_url
      # Must implement
      raise NotImplementedError
    end

    def form_params
      # Must implement
      raise NotImplementedError
    end

    def element_matcher
      # Must implement
      raise NotImplementedError
    end
  end
end
