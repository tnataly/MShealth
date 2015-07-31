require "MShealth/version"
require "MShealth/client"
require "MShealth/configuration"
require "MShealth/mash"
require "MShealth/errors"


require 'time'

module MShealth
  class << self
    def client
      @client ||= Client.new
    end

    def configure(&block)
      client.configure(&block)
    end
  end
end
