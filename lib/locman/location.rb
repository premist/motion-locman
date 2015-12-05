module Locman
  class Location
    attr_accessor :latitude, :longitude, :altitude, :floor,
                  :accuracy, :altitude_accuracy,
                  :determined_at

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

    def initialize(params = {})
      params.each { |key, value| send("#{key}=", value) }
    end
  end
end
