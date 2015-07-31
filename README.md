# MShealth [![Gem Version](https://badge.fury.io/rb/MShealth.svg)](http://badge.fury.io/rb/MShealth)

Ruby API wrapper for the [Microsoft Health Cloud](http://developer.microsoftband.com/cloudAPI).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'MShealth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install MShealth

## Usage
Check [get started](http://developer.microsoftband.com/Content/docs/MS%20Health%20API%20Getting%20Started.pdf) on how to register application and the application authentication scheme.

Set the token:

```ruby
MShealth.configure do |c|
  c.token = "your token"
end
```

Then get client:

```ruby
client = MShealth.client
```

### Profile

```ruby
client.profile #Get the details about this user from their Microsoft Health profile.
```

### Devices

```ruby
client.device(id:'FFFF1700-FFFF-FFFF-8529-454E11000210') #Get the single device info
client.devices #Return a list devices
```

### Activities

```ruby
# Get the single activity. "details,minute_summaries,map_points" are optional.
activity = client.activity(id:"2519647921241112976",details:1,minute_summaries:1,map_points:1)
# Get all activities during the period in an array. "details,minute_summaries,map_points,activity_types" are optional.
activities = client.activities(start_time:Time.new(2015,5,27),
  end_time:Time.new(2015,7,29),
  activity_types:"Run,Sleep",
  details:1,
  minute_summaries:1,
  map_points:1)
```

### Summary

```ruby
# Get all summaries during the period in an array. "end_time,device_id" are optional.
summary = client.summary(period:'hourly',
  start_time:Time.new(2015,6,27),
  end_time:Time.new(2015,7,20),
  device_id:"FFFF1700-FFFF-FFFF-8529-454E11000210")
```

### Return object

All returns are stored in a hash-like Mash object. All naming of parameters are ruby-ish.(eg:firstName -> first_name)

```ruby
profile = client.profile
profile.first_name
# You can check the whole structure using to_yaml:
puts profile.to_yaml
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yielder/MShealth.

## Todo

- Add documentation
- Add oauth2 support

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
