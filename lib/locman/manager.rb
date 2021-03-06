module Locman
  # This wraps CLLocationManager in more Ruby way.
  class Manager
    # @return [Symbol] Desired accuracy of the location data.
    attr_accessor :accuracy

    # @return [Integer] The minimum horizontal distance threshold for on_update event.
    attr_accessor :distance_filter

    # @return [Boolean] Set whether location should be updated in the background or not.
    attr_accessor :background

    # @return [Proc] Proc function that will be called when there is a new location retrieval.
    attr_accessor :on_update

    # @return [Proc] Proc function that will be called when there is an error while retrieving the location.
    attr_accessor :on_error

    # @return [Proc] Proc function that will be called when there is a new visit event.
    attr_accessor :on_visit

    # @!visibility private
    AUTHORIZED_CONSTS = [
      KCLAuthorizationStatusAuthorized,
      KCLAuthorizationStatusAuthorizedAlways,
      KCLAuthorizationStatusAuthorizedWhenInUse
    ]

    # @!visibility private
    NOT_AUTHORIZED_CONSTS = [
      KCLAuthorizationStatusNotDetermined,
      KCLAuthorizationStatusRestricted,
      KCLAuthorizationStatusDenied
    ]

    # @!visibility private
    ACCURACY_MAP = {
      navigation: KCLLocationAccuracyBestForNavigation,
      best: KCLLocationAccuracyBest,
      ten_meters: KCLLocationAccuracyNearestTenMeters,
      hundred_meters: KCLLocationAccuracyHundredMeters,
      kilometer: KCLLocationAccuracyKilometer,
      three_kilometers: KCLLocationAccuracyThreeKilometers
    }

    # Creates a new Locman::Location instance.
    # @param options [Hash] Attributes that will be assigned on instance creation
    # @return [Locman::Manager]
    def initialize(params = {})
      params.each { |key, value| send("#{key}=", value) }

      @accuracy ||= :best
      @distance_filter ||= 0

      self
    end

    # Sets a desired accuracy.
    # @param accuracy [Symbol] Desired accuracy of the location data.
    def accuracy=(accuracy)
      fail(ArgumentError, "Invalid accuracy: #{accuracy}") if ACCURACY_MAP[accuracy].nil?
      manager.desiredAccuracy = ACCURACY_MAP[accuracy]
      @accuracy = accuracy
    end

    def distance_filter=(distance_filter)
      fail(ArgumentError, "Distance filter should be integer") unless distance_filter.is_a?(Integer)
      manager.distanceFilter = distance_filter
      @distance_filter = distance_filter
    end

    # Sets whether location should be updated on the background or not.
    def background=(background)
      if !background.is_a?(TrueClass) && !background.is_a?(FalseClass)
        fail(ArgumentError, "Background should be boolean")
      end

      manager.allowsBackgroundLocationUpdates = background
      @background = background
    end

    def after_authorize=(after_authorize)
      fail(ArgumentError, "Must provide proc") unless after_authorize.is_a?(Proc)
      @after_authorize = after_authorize
    end

    def on_update=(on_update)
      fail(ArgumentError, "Must provide proc") unless on_update.is_a?(Proc)
      @on_update = on_update
    end

    def on_error=(on_error)
      fail(ArgumentError, "Must provide proc") unless on_error.is_a?(Proc)
      @on_error = on_error
    end

    def on_visit=(on_visit)
      fail(ArgumentError, "Must provide proc") unless on_visit.is_a?(Proc)
      @on_visit = on_visit
    end

    def authorize!
      return true unless CLLocationManager.authorizationStatus == KCLAuthorizationStatusNotDetermined
      manager.requestAlwaysAuthorization
    end

    def authorized?(status = nil)
      status ||= CLLocationManager.authorizationStatus

      if AUTHORIZED_CONSTS.include? status
        return true
      elsif NOT_AUTHORIZED_CONSTS.include? status
        return false
      end

      nil
    end

    def update!
      if CLLocationManager.authorizationStatus != KCLAuthorizationStatusAuthorized
        fail(Exception, "Location permission is not authorized by user")
      end

      manager.startUpdatingLocation
    end

    def stop_update!
      manager.stopUpdatingLocation
    end

    def update_significant!
      manager.startMonitoringSignificantLocationChanges
    end

    def stop_update_significant!
      manager.stopMonitoringSignificantLocationChanges
    end

    def update_visits!
      manager.startMonitoringVisits
    end

    def stop_update_visits!
      manager.stopMonitoringVisits
    end

    # Delegates

    def locationManager(manager, didChangeAuthorizationStatus: status)
      @after_authorize.call(authorized?(status)) unless @after_authorize.nil?
    end

    def locationManager(manager, didFailWithError: error)
      @on_error.call(error) unless @on_error.nil?
    end

    def locationManager(manager, didUpdateLocations: cl_locations)
      locations = cl_locations.map do |cl_location|
        Locman::Location.create_from_cl_location(cl_location)
      end

      @on_update.call(locations) unless @on_update.nil?
    end

    def locationManager(manager, didVisit: cl_visit)
      visit = Locman::Visit.create_from_cl_visit(cl_visit)

      @on_visit.call(visit) unless @on_visit.nil?
    end

    private

    def manager
      @manager ||= begin
        manager = CLLocationManager.new
        manager.delegate = self

        manager
      end
    end
  end
end
