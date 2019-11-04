require 'singleton'
require_relative '../driver'
require_relative '../driver_trip'
require_relative '../../services/trip_service'

class ModelFactory
  include Singleton

  @@drivers = []
  @@driver_trips = []

  def drivers
    @@drivers
  end

  def driver_trips
    @@driver_trips
  end

  def create(type, data)
    case type
    when TripService::DRIVER
      create_driver(data[:driver_name])
    when TripService::TRIP
      create_driver_trip(data[:driver_name], data[:trip])
    else
      puts 'Invalid command type'
    end
  end

  def clear_all
    drivers.clear
    driver_trips.clear
  end

  private

  # find_or_create_by for driver
  def create_driver(name)
    driver = @@drivers.select { |d| d.name.casecmp(name).zero? }.first
    if driver.nil?
      driver = Driver.new(name)
      @@drivers << driver
    end
    driver
  end

  # upsert for driver_trip
  def create_driver_trip(driver_name, trip)
    driver_names = @@driver_trips.map(&:driver_name)
    idx = driver_names.find_index { |n| n.casecmp(driver_name).zero? }
    if idx.nil?
      driver_trip = DriverTrip.new(driver_name, trip)
      @@driver_trips << driver_trip
    else
      @@driver_trips[idx].trips << trip
      driver_trip = @@driver_trips[idx]
    end
    driver_trip
  end
end
