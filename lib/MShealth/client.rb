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
      MShealth::Mash.new(response)
    end

    def devices
      response = handle_response("/"+configuration.api_version+"/me/Devices",
      :headers => {"Authorization" => "bearer "+configuration.token})
      devices = []
      response['deviceProfiles'].each do |device|
        devices << MShealth::Mash.new(device)
      end
      devices
    end

    def device(id:)
      response = handle_response("/"+configuration.api_version+"/me/Devices/"+id,
      :headers => {"Authorization" => "bearer "+configuration.token})
      MShealth::Mash.new(response)
    end

    def summary(period:,start_time:,**options)
      query = {}
      query['startTime'] = start_time.iso8601
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
        result << MShealth::Mash.new(summary)
      end

      while response.key?("nextPage")
        response = handle_response(response['nextPage'],:headers => {"Authorization" => "bearer "+configuration.token})
        response['summaries'].each do |summary|
          result << MShealth::Mash.new(summary)
        end
      end

      result
    end

    def activity(id:,**options)
      query = {}
      query['activityIncludes'] = ""
      query['activityIncludes'] += "Details," if options.key?(:details)
      query['activityIncludes'] += "MinuteSummaries," if options.key?(:minute_summaries)
      query['activityIncludes'] += "MapPoints," if options.key?(:map_points)
      if query['activityIncludes'] == ""
        query.delete('activityIncludes')
      else
        # Note: ...exclusive end, .. inclusice end
        query['activityIncludes'] = query['activityIncludes'][0...-1]
      end

      response = handle_response("/"+configuration.api_version+"/me/Activities/"+id,
      :headers => {"Authorization" => "bearer "+configuration.token},
      :query => query)

      MShealth::Mash.new(response)

    end

    def activities(start_time:,end_time:,**options)
      query = {}

      query['startTime'] = start_time.iso8601
      query['endTime'] = end_time.iso8601


      query['activityIncludes'] = ""
      query['activityIncludes'] += "Details," if options.key?(:details)
      query['activityIncludes'] += "MinuteSummaries," if options.key?(:minute_summaries)
      query['activityIncludes'] += "MapPoints," if options.key?(:map_points)
      if query['activityIncludes'] == ""
        query.delete('activityIncludes')
      else
        query['activityIncludes'] = query['activityIncludes'][0...-1]
      end

      query['activityTypes'] = options[:activity_types] if options.key?(:activity_types)

      response = response = handle_response("/"+configuration.api_version+"/me/Activities",
      :headers => {"Authorization" => "bearer "+configuration.token},
      :query => query)

      result = []

      types = ['bike','freePlay','golf','guidedWorkout','run','sleep']

      types.each do |type|
        name = type + 'Activities'
        if !response[name].nil?
          response[name].each do |activity|
            result << MShealth::Mash.new(activity)
          end
        end
      end

      while response.key?("nextPage")
        response = handle_response(response['nextPage'],:headers => {"Authorization" => "bearer "+configuration.token})
        types.each do |type|
          name = type + 'Activities'
          if !response[name].nil?
            response[name].each do |activity|
              result << MShealth::Mash.new(activity)
            end
          end
        end
      end

      result
    end

    def handle_response(*args)
      response = self.class.get(*args)

      case response.code.to_s
      when "401"
        raise MShealth::Errors::UnauthorizedError.new, response
      when "400"
        raise MShealth::Errors::BadRequestError.new, response
      when "403"
        raise MShealth::Errors::ForbiddenError.new, response
      when "404"
        raise MShealth::Errors::NotFoundError.new, response
      when "429"
        raise MShealth::Errors::TooManyRequestsError.new, response
      when "500"
        raise MShealth::Errors::ServerError.new, response
      when "200"
        return response
      else
        puts response.code.to_s
      end

    end
  end

end
