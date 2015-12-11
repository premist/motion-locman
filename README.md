# motion-locman

Simple location library for Rubymotion

## Installation

Add this line to your application's Gemfile:

    gem "motion-locman", "~> 0.3"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-locman

## Usage

Initialize a new **Locman::Manager**, request for user authorization:

```ruby
@manager = Locman::Manager.new(
  background: true, # for background udpates
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
