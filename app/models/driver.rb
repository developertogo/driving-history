require_relative 'factory/model_factory'
require_relative 'driver_trip'

class Driver
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.all
    ModelFactory.instance.drivers
  end

  def trips
    travel = DriverTrip.all.select { |dt| dt.driver_name.casecmp(name).zero? }
    return [] if travel.size.zero?

    travel.first.trips
  end
end
