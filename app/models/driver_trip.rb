require_relative 'factory/model_factory'

class DriverTrip
  attr_reader :driver_name
  attr_accessor :trips

  def initialize(driver_name, trip)
    @driver_name = driver_name
    @trips = trip.empty? ? [] : [trip]
  end

  def self.all
    ModelFactory.instance.driver_trips
  end
end
