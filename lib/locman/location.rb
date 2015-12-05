module Locman
  # Yolo
  class Location
    # @return [Float] Latitude coordinate of the location.
    attr_accessor :latitude

    # @return [Float] Longitude coordinate of the location
    attr_accessor :longitude

    # @return [Float] Altitude distance measurement of the location, in meters.
    attr_accessor :altitude

    # @return [Integer] The logical floor of the building.
    attr_accessor :floor

    # @return [Float] Latitude and longitude measurement accuracy, in meters.
    attr_accessor :accuracy

    # @return [Float] Altitude measurement accuracy, in meters.
    attr_accessor :altitude_accuracy

    # @return [Time] The time at which this location was determined
    attr_accessor :determined_at

    # Creates a new Locman::Location instance from CLLocation object.
    # @param cl_location [CLLocation]
    # @return [Locman::Location]
    def self.create_from_cl_location(cl_location)
      Locman::Location.new(
        latitude: cl_location.coordinate.latitude,
        longitude: cl_location.coordinate.longitude,
        altitude: cl_location.altitude,
        floor: cl_location.floor.nil? ? nil : cl_location.floor.level,
        accuracy: cl_location.horizontalAccuracy,
        altitude_accuracy: cl_location.verticalAccuracy,
        determined_at: cl_location.timestamp
      )
    end

    # Creates a new Locman::Location instance.
    # @param options [Hash] Attributes that will beassigned on instance creation
    # @return [Locman::Location]
    def initialize(options = {})
      options.each { |key, value| send("#{key}=", value) }
      self
    end
  end
end
