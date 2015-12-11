motion-locman
=============

Simple and easy location monitoring for RubyMotion


## Installation

Add this line to your application's Gemfile:

    gem "motion-locman", "~> 0.3"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-locman


## Preparing Rakefile

Before you start, you need to add **NSLocationAlwaysUsageDescription** and **NSLocationWhenInUseUsageDescription** key to the Info.plist with appropriate message. For example, add this on your `Motion::Project::App.setup` block:

```ruby
app.info_plist["NSLocationAlwaysUsageDescription"] = "We utilize location data to enhance your app experience."
app.info_plist["NSLocationWhenInUseUsageDescription"] = "We utilize location data to enhance your app experience."
```

In addition, if you want to get an location data update on background, add this to your `Motion::Project::App::Setup` block:

```ruby
app.info_plist["UIBackgroundModes"] = ["location"]
```


## Usage

Initialize a new **Locman::Manager**, request for user authorization:

```ruby
@manager = Locman::Manager.new(
  background: true, # for background updates
  accuracy: :ten_meters,
  distance_filter: 20 # in meter
)

@manager.after_authorize = lambda do |authorized|
  puts "Authorized!" if authorized
end

@manager.authorize!
```

Start monitoring and receiving location updates:

```ruby
@manager.on_update = lambda do |locations|
  locations.each { |loc| puts "(#{loc.latitude}, #{loc.longitude})" }
end

@manager.update! # Starts receiving normal location updates
@manager.update_significant! # Starts receiving significant location updates
```

Start monitoring and receiving visits:

```ruby
@manager.on_visit = lambda do |visit|
  puts "#{visit.latitude},#{visit.longitude} @ #{visit.departed_at}~#{visit.arrived_at}"
end

@manager.update_visits! # Start receiving visit updates
```

## License

MIT
