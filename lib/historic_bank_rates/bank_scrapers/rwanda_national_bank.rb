require_relative 'rate_scraper.rb'
require 'csv'    

module HistoricBankRates
  module BankScrapers
    class RwandaNationalBank < HistoricBankRates::BankScrapers::RateScraper

      def base_currency
        'RWF'
      end

      private

      def rates
        response = Net::HTTP.post_form(URI(form_url), form_params)
        csv = CSV.parse(response.body, :headers => true)
        Hash[csv.map do |row|
          currency = row['Code']&.strip
          next if currency.nil? || currency.empty?
          value = row['average value']&.strip.delete(',')
          next if value.nil? || value.empty?
          [currency, Float(value)] rescue nil
        end.compact]
      rescue CSV::MalformedCSVError
        {}
      end

      def form_url
        @form_url ||= 'https://www.bnr.rw/footer/quick-links/exchange-rate/?tx_bnrcurrencymanager_master[action]=archive&tx_bnrcurrencymanager_master[controller]=Currency'
      end

      def form_params
        {
          'tx_bnrcurrencymanager_master[from_date]' => start_date.strftime('%Y/%m/%d'), #2016/12/31
          'tx_bnrcurrencymanager_master[date]' => start_date.strftime('%Y/%m/%d'), #2016/12/31
          'tx_bnrcurrencymanager_master[download]' => 'Download'
        }
      end
    end
  end
end
