require_relative "../test_helper"


class ClientTest < Minitest::Test

  def setup
    @client = MShealth::Client.new
    @client.configure do |c|
      c.token = 'EwCYAvF0BAAUkWhN6f8bO0+g89MA1fmZueWyRkQAAUgjUEZIUhw+EbGV7++83/Q1MZbgUbg6eh1RhfVtlxx93T+AeuVYsxd0BWwu93RWNoW6p3QeJYuhZVz3W6ayLsFkWAZDejTDGU6WKGVLfmNPca0BLn5OpvtQIS4cOJTJKaE4ffzoBWgesX9X8nj4xTTs8HpjklfBIlAAedH0mJybydT84ZKXAtMBa/Wina4WaNBFP43xhKeBAPa27Wr6O3oqZvgMzURiSnLexNEEcnVXxaUH9HqOY6Ik5S9xGuA/xIdLRqeaFM9qZG4pJLJkEqdAGm/9nyRNU+8K56Nn73I1gpEAsQPJMo6sTuHKDErEdHdbL/ILhzDSLykyIxz7/qEDZgAACBywHKzlA0vraAEFCP9QrMEre9ZhvZXzdliwXDJwKmsCF7+ldRwBnqzpxczqTo9Toc/RV+N9UjOs7+QYxgEu+UX+biHMKkzba2e+PDru8S5gV4Axylfs1DKBxRwYVqgvckHWwkMW7kGH8kEyTq62F7Ywj+tyAPf+9KIwPyMDo3M7BvKwH3Ocqjs/HQFfJDsyUdB8IU0rH7hWGWQWNhsZW2QCGNhZp27qZCoU6l+3w3xGxmy+DFv1PUGZVXCDKNUgcrJRCxENWjeQDeQUr0HfNCr6UGkdBNPRVcUiQ0pKhWSZbAxrtW4Iw4oIbO7EO28nC8z3TYyx/rXPSqZMRhvpH693UuQM4YJLMTVXXoDSNo9MeLvu+5JY+cu0iLYYY45gEkCJGyLYn8J3sY3jy/bl6TwUpc3zUDkz5bzaDxA1VKc9BS+7ArAmDIhPUiGmDFWM9ySN2hDbTrpKtzWxR/Wx4rBP6FiniJiLBogSDwKaVAkkieaAAQ=='
    end
  end

  def test_client_exist
    assert_equal MShealth::Client, @client.class
  end

  def test_return_profile
    VCR.use_cassette('profile') do
      profile = @client.profile
      assert_equal "weihua",profile.first_name
      assert_equal Time,profile.last_update_time.class
      assert_equal nil,profile.last_name
    end
  end

  def test_devices
    VCR.use_cassette('devices') do
      devices = @client.devices
      assert_equal Array, devices.class
      assert_equal 'Band', devices[0].device_family
    end
  end

  def test_device
    VCR.use_cassette('one_device') do
      device = @client.device(id:'FFFF1700-FFFF-FFFF-8529-454E11000210')
      assert_equal MShealth::Mash, device.class
      assert_equal 'Band', device.device_family
    end
  end

  def test_summary_simple
    VCR.use_cassette('summary_day') do
      summary = @client.summary(period:'daily',start_time:Time.new(2015,7,27))
      assert_equal Array, summary.class
      assert_equal MShealth::Mash, summary[0].class
      assert_equal 'Daily', summary[0].period
      assert_equal Time.iso8601("2015-07-30T23:00:00.000+00:00"), summary[0].start_time


      calories = summary[0].calories_burned_summary
      assert_equal "Daily", calories.period

      heartrate = summary[0].heart_rate_summary
      assert_equal "Daily", heartrate.period

      distance = summary[0].distance_summary
      assert_equal "Daily", distance.period
    end
  end

  def test_summary_hourly
    VCR.use_cassette('hourly_summary') do
      summary = @client.summary(period:'hourly',start_time:Time.new(2015,6,27),end_time:Time.new(2015,7,20))
      assert summary.size > 500
    end
  end

  def test_activity
    VCR.use_cassette('one_activity') do
      activity = @client.activity(id:"2519647921241112976",details:1,minute_summaries:1)
      assert_equal "Run", activity.activity_type
      assert activity.minute_summaries
    end
  end

  def test_activities
    VCR.use_cassette('activities') do
      activities = @client.activities(start_time:Time.new(2015,5,27),end_time:Time.new(2015,7,29))
      assert_equal 7, activities.length
    end
  end

  def test_unauthorized_error
    VCR.use_cassette('UnauthorizedError') do
      assert_raises(MShealth::Errors::UnauthorizedError) do
        activities = @client.activities(start_time:Time.new(2015,5,27),end_time:Time.new(2015,7,29))
      end
    end
  end

  def test_wrong_request
    VCR.use_cassette('wrong_request') do
      assert_raises(MShealth::Errors::BadRequestError) do
        device = @client.device(id:"asd")
      end
    end
  end


end
