require_relative '../../spec_helper'

describe HistoricBankRates::RateScraper do
  it { is_expected.to respond_to(:call) }
  it { is_expected.to respond_to(:base_currency) }

  describe '#base_currency' do
    it 'raises an error' do
      expect { HistoricBankRates::RateScraper.new.base_currency }.to raise_error(NotImplementedError)
    end
  end
end
