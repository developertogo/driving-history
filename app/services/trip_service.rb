require 'time'

module TripService
  DRIVER = 'driver'.freeze
  TRIP = 'trip'.freeze

  def self.parse_input(line)
    return nil if line.empty?

    columns = line.split
    return nil if columns.size < 2

    command = columns.shift.downcase
    driver_name = ''
    trip = {}

    case command
    when DRIVER
      driver_name = columns.shift
    when TRIP
      return nil if columns.size < 4

      driver_name = columns.shift
      trip = {
        start: columns.shift,
        stop: columns.shift,
        distance: columns.shift
      }
    else
      return nil
    end

    { driver_name: driver_name, command: command, trip: trip }
  end

  def self.summary(driver)
    default_trip_summary = {
      driver_name: driver.name,
      distance: 0,
      duration: 0,
      avg_speed: 0
    }
    return default_trip_summary if driver.trips.empty?

    trip_summary = default_trip_summary

    driver.trips.each do |trip|
      next if trip.empty?

      distance, duration, avg_speed = trip_duration_and_avg_speed(trip)
      next if discard?(avg_speed)

      trip_summary[:distance] += distance
      trip_summary[:duration] += duration
    end

    trip_summary[:avg_speed] = trip_summary_avg_speed(trip_summary)
    return default_trip_summary if discard?(trip_summary[:avg_speed])

    trip_summary[:distance] = trip_summary[:distance].round
    trip_summary[:duration] = trip_summary[:duration].round(2)

    trip_summary
  end

  private_class_method def self.discard?(avg_speed)
    !avg_speed.between?(5, 100)
  end

  private_class_method def self.trip_duration_and_avg_speed(params)
    trip = {
      start: Time.parse(params[:start]),
      stop: Time.parse(params[:stop]),
      distance: params[:distance].to_f
    }
    duration = avg_speed = 0
    return [trip[:distance], duration, avg_speed] if trip[:stop] <= trip[:start]

    duration = (trip[:stop] - trip[:start]) / 3600
    avg_speed = trip[:distance] / duration

    [trip[:distance], duration, avg_speed]
  end

  private_class_method def self.trip_summary_avg_speed(trip_summary)
    return 0 if trip_summary[:distance].zero? || trip_summary[:duration].zero?

    (trip_summary[:distance] / trip_summary[:duration]).round
  end
end
