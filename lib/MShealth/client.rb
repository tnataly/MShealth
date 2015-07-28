require 'httparty'

module MShealth

  class Client


    include HTTParty
    base_uri 'https://api.microsofthealth.net'

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def profile
      response = handle_response("/"+configuration.api_version+"/me/Profile",
      :headers => {"Authorization" => "bearer "+configuration.token})
      MShealth::Model::Profile.new(response)
    end

    def devices
      response = handle_response("/"+configuration.api_version+"/me/Devices",
      :headers => {"Authorization" => "bearer "+configuration.token})
      devices = []
      response['deviceProfiles'].each do |device|
        devices << MShealth::Model::Device.new(device)
      end
      devices
    end

    def device(id)
      response = handle_response("/"+configuration.api_version+"/me/Devices/"+id,
      :headers => {"Authorization" => "bearer "+configuration.token})
      MShealth::Model::Device.new(response)
    end

    def summary(period:,start_time:,**options)
      start_time_iso = start_time.iso8601
      query = {}
      query['startTime'] = start_time_iso
      query['endTime'] = options[:end_time].iso8601 if options.key?(:end_time)
      query['deviceIds'] = options[:device_id] if options.key?(:device_id)

      period_str = nil
      response = nil

      case period
      when "hourly"
        period_str = 'Hourly'
      when "daily"
        period_str = 'Daily'
      else
      end

      response = handle_response("/"+configuration.api_version+"/me/Summaries/"+period_str,
      :headers => {"Authorization" => "bearer "+configuration.token},
      :query => query)

      result = []

      response['summaries'].each do |summary|
        result << MShealth::Model::Summary.new(summary)
      end

      while response.key?("nextPage")
        response = handle_response(response['nextPage'],:headers => {"Authorization" => "bearer "+configuration.token})
        response['summaries'].each do |summary|
          result << MShealth::Model::Summary.new(summary)
        end
      end

      result
    end

    def handle_response(*args)
      response = self.class.get(*args)

      case response.code.to_s
      when "401"
        puts "Unauthorized"
      when "200"
        return response
      else
        puts response.code.to_s
      end

      response
    end
  end

end
