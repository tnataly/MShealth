module MShealth
  module Model
    class HeartRateSummary
      attr_reader :period, :average_heart_rate, :peak_heart_rate, :lowest_heart_rate

      def initialize(heartrate)
        @period = heartrate['period']
        @average_heart_rate = heartrate['averageHeartRate']
        @peak_heart_rate = heartrate['peakHeartRate']
        @lowest_heart_rate = heartrate['lowestHeartRate']
      end

    end
  end
end
