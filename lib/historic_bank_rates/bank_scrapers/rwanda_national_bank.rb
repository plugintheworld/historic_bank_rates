require_relative 'rate_scraper.rb'

module HistoricBankRates
  module BankScrapers
    class RwandaNationalBank < HistoricBankRates::BankScrapers::RateScraper

      def base_currency
        'RWF'
      end

      private

      def rates
        response = Net::HTTP.post_form(URI(form_url), form_params)
        dom = Nokogiri::HTML(response.body)
        rows = dom.css(element_matcher)

        Hash[(0...rows.length).step(4).map do |index|
        currency = rows[index].css(':nth-child(1)').text
          next if currency.empty?
          avrg = rows[index+1].text
          next if avrg.empty?

          [currency, Float(avrg)] rescue nil
        end.compact]
      end

      def form_url
        @form_url ||= 'http://www.bnr.rw/index.php?id=89'
      end

      def form_params
        { 'tx_excratearch_excratearch[date]' => '12-07-2016',
          'tx_excratearch_excratearch[getHistory]' => 'Get+History'
        }
      end

      def element_matcher
        'tbody > tr > td'
      end
    end
  end
end
