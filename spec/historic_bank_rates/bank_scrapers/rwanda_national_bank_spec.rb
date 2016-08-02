require_relative '../../spec_helper'

describe HistoricBankRates::BankScrapers::RwandaNationalBank do
  let(:rate_scraper) { HistoricBankRates::BankScrapers::RwandaNationalBank.new }
  let(:valid_date) { Date.new(2016, 06, 16) }

  describe '#base_currency' do
    it 'does not raise an error' do
      expect { rate_scraper.base_currency }.to_not raise_error
    end
  end

  describe '#call' do
    context 'when the scraper is successful', :vcr do
      subject { rate_scraper.call(valid_date) }
      it { should be_a_kind_of(Hash) }
      it { should include('ETB', 'KWD', 'XOF', 'EUR', 'USD') }
    end

    context 'when the scraper fails', :vcr do
      before do
        rate_scraper.form_url = invalid_url
      end
      subject { rate_scraper.call(valid_date) }
      it { should be_a_kind_of(Hash) }
      it { should_not include('ETB', 'KWD', 'XOF', 'EUR', 'USD') }
    end
  end

  def invalid_url
    'http://www.bnr.rw/index'
  end
end
