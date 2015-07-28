module MShealth
  module Model
    class Profile

      attr_reader :first_name, :middle_name, :last_name, :birthdate
      attr_reader :postal_code, :gender, :height, :weight
      attr_reader :preferred_locale, :last_update_time

      def initialize(response)
        @first_name = response['firstName']
        @middle_name = response['middleName']
        @last_name = response['lastName']
        @birthdate = Time.iso8601(response['birthdate']) unless response['birthdate'].nil?
        @postal_code = response['postalCode']
        @gender = response['gender']
        @height = response['height']
        @weight = response['weight']
        @preferred_locale = response['preferredLocale']
        @last_update_time = Time.iso8601(response['lastUpdateTime']) unless response['lastUpdateTime'].nil?
      end

    end
  end
end
