module MShealth
  DEFAULT_VERSION = "V1"

  class Configuration

    attr_accessor :token, :api_version

    def initialize
      @api_version = DEFAULT_VERSION
    end
  end

end
