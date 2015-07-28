$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'MShealth'

require 'vcr'
require 'webmock/minitest'
require 'minitest/autorun'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures'
  c.hook_into :webmock
end
