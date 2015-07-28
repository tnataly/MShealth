module MShealth
  module Model
    class DistanceSummary

      attr_reader :period, :total_distance, :total_distance_on_foot, :actual_distance
      attr_reader :altitude_gain, :altitude_loss, :max_altitude, :min_altitude
      attr_reader :way_point_distance, :speed, :pace, :overall_pace

      def initialize(distance)
        @period = distance["period"]
        @total_distance = distance["totalDistance"]
        @total_distance_on_foot = distance["totalDistanceOnFoot"]
        @actual_distance = distance["actualDistance"]
        @altitude_gain = distance["altitudeGain"]
        @altitude_loss = distance["altitudeLoss"]
        @max_altitude = distance["maxAltitude"]
        @min_altitude = distance["minAltitude"]
        @way_point_distance = distance["waypointDistance"]
        @speed = distance["speed"]
        @pace = distance["pace"]
        @overall_pace = distance["overallPace"]

      end

    end
  end
end
