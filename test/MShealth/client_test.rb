require_relative "../test_helper"


class ClientTest < Minitest::Test

  def setup
    @client = MShealth::Client.new
    @client.configure do |c|
      c.token = 'EwCYAvF0BAAUkWhN6f8bO0+g89MA1fmZueWyRkQAAfeFTBNsH5vZFTDxj+qimW6tR1AOguS267/dhBW27j6AMtgFh6oElz+t1ESJdobI1M17+1Ee0gYSfBomJ3nIiyzWbVCOTURC/BlHeEteEyOUi+NeZDXLSskS64Lro4qsPOGMcEjVVYze8rP9Iye+9EZDnjhx5LCZ7eigYdgz8PJ96PeQPAODA4VzTBAFzAX71ob+ORjqyTLYxYRWh2yxbRz59CvwD5ELLkr+hS456O2PJjwvAgDHv2MfX+HwYgQ8phfqUvZhEmJEo4TLxM2UvYy20MPt8sXEHJ5VEOWN84fTvUHGMyYFhxxPOZafwyC8s4iWtbE+UjUWCvdyc3ei9JQDZgAACK200ZbAsFOyaAGX9TN2BCtwse/doUPB7nbhxhShIuzEWg/y4CQbxtSIZkKng3mWsjvPpbRK0eD+DOHUMgIMbnM9VgUEbLj11y9NqBSd9clscqfqlq2hRxREIXRyNmEuZMoprmEM3lAuXubGxS3XC3KewoLlhLlxmKLc2NlmqZKofKnojFOsT9x8IHa6cF0ct2jCAJJn87xT96KqLw199wu8W+H5rWTTAuyeAvAQ8tGQ1euvomycwQqnIZpQydqgdzujRNGp+GwZTkZ3LAIG3SDz4YsEPneprGYi4cjtjrWcRqfF0La5g9DNAcT5+ntux1tFYLd6Ma4FbbWtM2YyYLkb6gQyJAGDykputxDxN6WUOru5pykszVuFSpGWFyD3k1IGCxUNjou6PxixwRuDyOGxuWlyEq2gbOPnfStYdx/jEHSrsDOqroafJpo1W6QPImZS1xrhs6OGkQC+dXISqEQJsbcLROjCyN6piI71E7eBx7uAAQ=='
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
      assert_equal MShealth::Model::Device, devices[0].class
      assert_equal 'Band', devices[0].device_family
    end
  end

  def test_device
    VCR.use_cassette('one_device') do
      device = @client.device('FFFF1700-FFFF-FFFF-8529-454E11000210')
      assert_equal MShealth::Model::Device, device.class
      assert_equal 'Band', device.device_family
    end
  end

  def test_summary_simple
    VCR.use_cassette('summary_one_day') do
      summary = @client.summary(period:'daily',start_time:Time.new(2015,7,27))
      assert_equal Array, summary.class
      assert_equal 3, summary.length
      assert_equal MShealth::Model::Summary, summary[0].class
      assert_equal 'Daily', summary[0].period
      assert_equal Time.iso8601("2015-07-28T23:00:00.000+00:00"), summary[0].start_time

      calories = summary[0].calories_summary
      assert_equal MShealth::Model::CaloriesSummary, calories.class
      assert_equal "Daily", calories.period

      heartrate = summary[0].heart_rate_summary
      assert_equal MShealth::Model::HeartRateSummary, heartrate.class
      assert_equal "Daily", heartrate.period

      distance = summary[0].distance_summary
      assert_equal MShealth::Model::DistanceSummary, distance.class
      assert_equal "Daily", distance.period
    end
  end

  def test_summary_hourly
    VCR.use_cassette('hourly_summary') do
      summary = @client.summary(period:'hourly',start_time:Time.new(2015,6,27),end_time:Time.new(2015,7,20))
      puts summary[500].to_yaml
      assert summary.size > 500
    end
  end


end
