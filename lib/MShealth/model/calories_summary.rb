module MShealth
  module Model
    class CaloriesSummary
      attr_reader :period, :total_calories

      def initialize(calories)
        @period = calories['period']
        @total_calories = calories['totalCalories']
      end
    end
  end
end
