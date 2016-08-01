Gem::Specification.new do |s|
  s.name         = 'historic_bank_rates'
  s.version      = '0.2.2'
  s.platform     = Gem::Platform::RUBY
  s.date         = '2016-08-01'
  s.summary      = 'Scrapes various bank websites to generate a list of
                    currencies and their historic rates.'
  s.description  = "Wraps a simple scraper to retrieve the historic exchange
                    rates of specific banks. Returns the average (between buy
                    and sell) rates for any day specified (if date isn't
                    specified it defaults to yesterday)."
  s.authors      = ['Alexander Donkin']
  s.email        = ['alexander_donkin@yahoo.co.uk']
  s.homepage     = 'http://github.com/plugintheworld/historic_bank_rates'
  s.license      = 'MIT'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'

  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'nyan-cat-formatter'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'

  s.require_path = 'lib'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
end
