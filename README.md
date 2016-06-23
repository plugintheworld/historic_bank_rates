# Historic Bank Rates
[![Build Status](https://travis-ci.org/plugintheworld/historic_bank_rates.svg?branch=master)](https://travis-ci.org/plugintheworld/historic_bank_rates)

Wraps a simple scraper to retrieve the historic exchange rates. Returns the average rates for yesterday or any day specified and supported by the Central Bank of Kenya.

## Install

Add this line to your application's Gemfile:

  ```ruby
  gem 'historic_bank_rates'
  ```

And then execute:

  ```ruby
  $ bundle
  ```

Or install it yourself as:

  ```ruby
  $ gem install historic_bank_rates
  ```

## Usage

### Initialize

  ```ruby
  hbr = HistoricBankRates.new(CentralBankOfKenya, Date.new(2015, 10, 24))
  hbr.import! # => true
  ```

import! returns true if rates have been found. Might also throw HTTP errors. It will also return false when requesting rates for weekend days.

### Retrieve a specific rate

  ```ruby
  hbr.rate('KES', 'EUR') # => 112.2322
  ```

Get all available currencies:

  ```ruby
  hbr.currencies # => ['ZAR', 'USD', 'EUR', 'RWF'… ]
  ```

Get all rates

  ```ruby
  hbr.rates # => { 'ZAR'=>6.4373, 'USD'=>100.6606, … }
  ```

## Legal

The author of this gem is not affiliated with any of the banks referenced/scraped by the gem.

### License

MIT, see LICENSE file

### No Warranty

The Software is provided "as is" without warranty of any kind, either express or implied, including without limitation any implied warranties of condition, uninterrupted use, merchantability, fitness for a particular purpose, or non-infringement.
