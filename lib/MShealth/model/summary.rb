module MShealth
  module Model
    class Summary
      attr_reader :user_id, :start_time, :end_time, :period
      attr_reader :duration, :steps_taken, :active_hours
      attr_reader :calories_summary, :heart_rate_summary, :distance_summary

      def initialize(summary)
        @user_id = summary['userId']
        @start_time = Time.iso8601(summary['startTime']) unless summary['startTime'].nil?
        @end_time = Time.iso8601(summary['endTime']) unless summary['endTime'].nil?
        @period = summary['period']
        @duration = summary['duration']
        @steps_taken = summary['stepsTaken']
        @active_hours = summary["activeHours"]
        @calories_summary = MShealth::Model::CaloriesSummary.new(summary['caloriesBurnedSummary'])
        @heart_rate_summary = MShealth::Model::HeartRateSummary.new(summary['heartRateSummary'])
        @distance_summary = MShealth::Model::DistanceSummary.new(summary['distanceSummary'])
      end
    end
  end
end
