require_relative 'rate_scraper.rb'
module HistoricBankRates
  module BankScrapers
    class BankOfTanzania < HistoricBankRates::BankScrapers::RateScraper
      TRANSLATE = { 'Kenya SHS'         => 'KES',
                    'Uganda SHS'        => 'UGX',
                    'Rwandan Franc'     => 'RWF',
                    'Burundi Franc'     => 'BFI',
                    'USD'               => 'USD',
                    'Pound STG'         => 'GBP',
                    'EURO'              => 'EUR',
                    'Canadian $'        => 'CAD',
                    'Switz. Franc'      => 'CHF',
                    'Japanese YEN'      => 'JPY',
                    'Swedish Kronor'    => 'SEK',
                    'Norweg. Kronor'    => 'NOK',
                    'Danish Kronor'     => 'DKK',
                    'Australian $'      => 'AUD',
                    'Indian RPS'        => 'INR',
                    'Pakistan RPS'      => 'PKR',
                    'Zambian Kwacha'    => 'ZAK',
                    'Malawian Kwacha'   => 'MWK',
                    'Mozambique-MET'    => 'MZN',
                    'Zimbabwe $'        => 'ZWD',
                    'SDR'               => 'XDR',
                    'S. African Rand'   => 'ZAR',
                    'UAE Dirham'        => 'AED',
                    'Singapore $'       => 'SGD',
                    'Honk Kong $'       => 'HKD',
                    'Saud Arabian Rial' => 'SAR',
                    'Kuwait Dinar'      => 'KWD',
                    'Botswana Pula'     => 'BWP',
                    'Chinese Yuan'      => 'CNY',
                    'Malaysia Ringgit'  => 'MYR',
                    'South Korea Won'   => 'KRW',
                    'Newzealand'        => 'NZD' }

      def base_currency
        'TZS'
      end

      private

      def rates
        response = Net::HTTP.post_form(URI(form_url), form_params)
        dom = Nokogiri::HTML(response.body)
        rows = dom.css(element_matcher)

        Hash[rows.map do |row|
               currency = TRANSLATE[row.css(':nth-child(1) font').text.split.join(' ')]
               buy = Float(row.css(':nth-child(3) font').text.delete(',')) rescue nil
               sell = Float(row.css(':nth-child(4) font').text.delete(',')) rescue nil
               next if currency.nil? || buy.nil? || sell.nil?

               # average of by and sell, divide by 100 b/c conversion is given in 100 units
               [currency, (buy + sell) / 200]
        end.compact]
      end

      def form_url
        @form_url ||= 'https://www.bot.go.tz/FinancialMarkets/ExchangeRates/ShowExchangeRates.asp'
      end

      def form_params
        {
          'SelectedExchandeDate' => start_date.strftime('%m/%d/%y')
        }
      end

      def element_matcher
        '#table1 > tr > td > table > tr > td > div > table > tr > td > table > tr'
      end
    end
  end
end
