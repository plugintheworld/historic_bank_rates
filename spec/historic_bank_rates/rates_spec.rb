require_relative '../spec_helper'

describe HistoricBankRates::Rates do
  let(:scraper_with_valid_rates) { instance_double("RateScraper",
                                                   :call => valid_rates,
                                                   :base_currency => example_base_currency) }
  let(:scraper_with_empty_rates) { instance_double("RateScraper",
                                                   :call => {},
                                                   :base_currency => example_base_currency) }

  let(:recent_rates) { HistoricBankRates::Rates.new(scraper_with_valid_rates,
                                                    Date.new(2016, 5, 30)) }
  let(:future_rates) { HistoricBankRates::Rates.new(scraper_with_empty_rates,
                                                    Date.new(2039, 2, 1)) }

  describe '#import!' do
    it 'returns true when rates could be retrieved' do
      expect(recent_rates.import!).to be_truthy
    end

    it 'returns false when there are no rates' do
      expect(future_rates.import!).to be_falsey
    end
  end

  describe '#currencies/.rates/.rate' do
    it 'throws an error when there are no rates' do
      expect { future_rates.rates }.to raise_error HistoricBankRates::MissingRates
      expect { future_rates.currencies }.to raise_error HistoricBankRates::MissingRates
      expect { future_rates.rate('ISO', 'ISO') }.to raise_error HistoricBankRates::MissingRates
    end
  end

  describe '#has_rates?' do
    it 'returns true when there are rates' do
      recent_rates.import!
      expect(recent_rates).to have_rates
    end

    it 'returns false when there are no rates' do
      expect(recent_rates).not_to have_rates
    end
  end

  describe '#rate' do
    before do
      recent_rates.import!
    end

    it 'returns a specific rate' do
      expect(recent_rates.rate(example_base_currency, 'EUR')).to eq 1 / euro_rate
    end

    it 'returns the inverse rate' do
      expect(recent_rates.rate('EUR', example_base_currency)).to eq euro_rate
    end

    it 'returns nil when currency is not known' do
      expect(recent_rates.rate('XXX', 'RWF')).to be_nil
      expect(recent_rates.rate('XXX', 'XXX')).to be_nil
    end
  end

  describe '#currencies' do
    it 'returns an array' do
      recent_rates.import!
      expect(recent_rates.currencies).to eq valid_rates.keys
    end
  end

  describe '#rates' do
    it 'returns all rates' do
      recent_rates.import!
      expect(recent_rates.rates).to eq valid_rates
    end
  end

  def valid_rates
    {
      'USD' => 100.6606,
      'GBP' => 147.3558,
      'EUR' => euro_rate,
      'ZAR' => 6.4373
    }
  end

  def euro_rate
    112.2322
  end

  def example_base_currency
    'KES'
  end
end
