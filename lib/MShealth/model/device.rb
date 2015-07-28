module MShealth
  module Model

    class Device
      attr_reader :id, :display_name, :last_sync, :device_family

      def initialize(response)
        @id = response['id']
        @display_name = response['displayName']
        @last_sync = Time.iso8601(response['lastSuccessfulSync']) unless response['lastSuccessfulSync'].nil?
        @device_family = response['deviceFamily']
      end



    end

  end
end
