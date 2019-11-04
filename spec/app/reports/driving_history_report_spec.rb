require 'spec_helper'

require_relative '../../../app/models/factory/model_factory'
require_relative '../../../app/reports/driving_history_report'

describe DrivingHistoryReport do
  let(:model_factory) { ModelFactory.instance }

  after do
    model_factory.clear_all
  end

  describe '.output_summary' do
    before do
      model_factory.create(TripService::DRIVER, driver_name: 'Paul')
    end

    context 'when trip is empty' do
      it 'outputs 0 miles' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: {})
        expect { DrivingHistoryReport.output_summary(Driver.all) }.to output("Paul: 0 miles\n").to_stdout
      end
    end

    context 'when one trip is made' do
      before do
        @trip = {
          start: '12:01',
          stop: '13:16',
          distance: '42.0'
        }
      end

      it 'outputs trip summary' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect { DrivingHistoryReport.output_summary(Driver.all) }.to output("Paul: 42 miles @ 34 mph\n").to_stdout
      end
    end

    describe 'two or more trips are made' do
      before do
        @trip1 = {
          start: '07:15',
          stop: '07:45',
          distance: '17.3'
        }
        @trip2 = {
          start: '06:12',
          stop: '06:32',
          distance: '21.8'
        }
      end

      context 'when two valid trips are made' do
        it 'outputs trip summary' do
          model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip1)
          model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip2)
          expect { DrivingHistoryReport.output_summary(Driver.all) }.to output("Paul: 39 miles @ 47 mph\n").to_stdout
        end
      end

      context 'when three trips are made, including one < 5 mph' do
        before do
          @trip3 = {
            start: '01:00',
            stop: '21:00',
            distance: '80.0'
          }
        end

        it 'outputs trip summary, discarding one < 5 mph' do
          model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip1)
          model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip2)
          model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip3)
          expect { DrivingHistoryReport.output_summary(Driver.all) }.to output("Paul: 39 miles @ 47 mph\n").to_stdout
        end
      end
    end
  end
end
