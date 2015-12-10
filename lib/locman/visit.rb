module Locman
  # This represents a single visit.
  class Visit
    attr_accessor :latitude, :longitude, :departed_at, :arrived_at

    # Creates a new Locman::Location instance from CLVisit object.
    # @param cl_visit [CLVisit]
    # @return [Locman::Location]
    def self.create_from_cl_visit(cl_visit)
      Locman::Visit.new(
        latitude: cl_visit.coordinate.latitude,
        longitude: cl_visit.coordinate.longitude,
        departed_at: cl_visit.departureDate,
        arrived_at: cl_visit.arrivalDate
      )
    end

    # Creates a new Locman::Location instance.
    # @param options [Hash] Attributes that will be assigned on instance creation
    # @return [Locman::Location]
    def initialize(options = {})
      options.each { |key, value| send("#{key}=", value) }
      self
    end
  end
end

