# motion-locman

Simple location library for Rubymotion

## Installation

Add this line to your application's Gemfile:

    gem "motion-locman"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-locman

## Usage

Initialize a new **Locman::Manager**, request for user authorization:

```ruby
@manager = Locman::Manager.new(
  accuracy: :ten_meters,
  distance_filter: 20 # in meter
)

@manager.after_authorize = lambda do |authorized|
  puts "Authorized!" if authorized
end

@manager.authorize!
```

Start receiving location updates:

```ruby
@manager.on_update = lambda do |locations|
  locations.each { |loc| puts "(#{loc.latitude}, #{loc.longitude})" }
end

@manager.start!
```

## License

MIT
