require_relative 'rate_scraper.rb'
require 'json'

module HistoricBankRates
  module BankScrapers
    class CentralBankOfKenya < HistoricBankRates::BankScrapers::RateScraper
      TRANSLATE = { 'US DOLLAR'         => 'USD',
                    'STG POUND'         => 'GBP',
                    'EURO'              => 'EUR',
                    'SA RAND'           => 'ZAR',
                    'KES / USHS'        => 'UGX',
                    'KES / TSHS'        => 'TZS',
                    'KES / RWF'         => 'RWF',
                    'KES / BIF'         => 'BIF',
                    'AE DIRHAM'         => 'AED',
                    'CAN $'             => 'CAD',
                    'S FRANC'           => 'CHF',
                    'JPY (100)'         => 'JPY',
                    'SW KRONER'         => 'SEK',
                    'NOR KRONER'        => 'NOK',
                    'DAN KRONER'        => 'DKK',
                    'IND RUPEE'         => 'INR',
                    'HONGKONG DOLLAR'   => 'HKD',
                    'SINGAPORE DOLLAR'  => 'SGD',
                    'SAUDI RIYAL'       => 'SAR',
                    'CHINESE YUAN'      => 'CNY',
                    'AUSTRALIAN $'      => 'AUD' }

      def base_currency
        'KES'
      end

      private

      def rates
        response = Net::HTTP.post_form(URI(form_url), form_params)
        data = JSON.parse(response.body)

        Hash[data['data'].map do |row|
               currency = TRANSLATE[row[1]]
               next if currency.nil? || currency.empty?
               avrg = row[2]
               next if avrg.nil? || avrg.empty?

               [currency, Float(avrg)] rescue nil
        end.compact]
      rescue JSON::ParserError
        {}
      end

      def form_url
        @form_url ||= 'https://www.centralbank.go.ke/wp-admin/admin-ajax.php?action=get_wdtable&table_id=32'
      end

      def form_params
        date = start_date.strftime('%d/%m/%y')
        {
          'draw' => 3,
          'columns' => [{
            'data' => 0,
            'name' => 'date_r',
            'searchable' => 'true',
            'search' => { 'value' => "#{date}~#{date}" }
          }],
          'start' => 0,
          'length' => 40,
          'sRangeSeparator' => '~'
        }
      end
    end
  end
end
