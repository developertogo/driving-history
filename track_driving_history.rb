require_relative 'app/models/factory/model_factory'
require_relative 'app/reports/driving_history_report'

ARGF.each_with_index do |line, index|
  next if line.strip.empty?

  data = TripService.parse_input(line)

  if data.nil?
    puts "Invalid input data found at line #{index + 1}. Please correct input, and try again."
    exit
  end

  model_factory = ModelFactory.instance
  model_factory.create(data[:command], data)
end

DrivingHistoryReport.output_summary(Driver.all)
