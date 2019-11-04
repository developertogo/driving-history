module DrivingHistoryReport
  def self.output_summary(drivers)
    summaries = []
    drivers.each do |driver|
      summaries << TripService.summary(driver)
    end

    summaries.sort_by! { |s| s[:distance] }
    summaries.reverse.each do |summary|
      puts format_output(summary)
    end
  end

  private_class_method def self.format_output(trip_summary)
    output = "#{trip_summary[:driver_name]}: #{trip_summary[:distance]} miles"
    output += " @ #{trip_summary[:avg_speed]} mph" unless trip_summary[:avg_speed].zero?
    output
  end
end
