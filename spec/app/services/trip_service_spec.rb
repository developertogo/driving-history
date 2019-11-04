require 'spec_helper'

require_relative '../../../app/models/factory/model_factory'
require_relative '../../../app/services/trip_service'

describe TripService do
  let(:model_factory) { ModelFactory.instance }

  after do
    model_factory.clear_all
  end

  describe '.parse_input' do
    context 'when driver input' do
      before do
        @input = 'Driver Matthew'
        @parsed_input_hash = {
          driver_name: 'Matthew',
          command: TripService::DRIVER,
          trip: {}
        }
      end

      it 'returns parsed hash of input line' do
        expect(TripService.parse_input(@input)).to eq(@parsed_input_hash)
      end
    end

    context 'when trip input' do
      before do
        @input = 'Trip Mark 04:45 05:00 4.0'
        @trip = {
          start: '04:45',
          stop: '05:00',
          distance: '4.0'
        }
        @parsed_input_hash = {
          driver_name: 'Mark',
          command: TripService::TRIP,
          trip: @trip
        }
      end

      it 'returns parsed hash of input line' do
        expect(TripService.parse_input(@input)).to eq(@parsed_input_hash)
      end
    end

    describe 'invalid input' do
      context 'when invalid command' do
        before do
          @input = 'Run Mark'
        end

        it 'aborts continuing reading input file' do
          expect(TripService.parse_input(@input)).to be_nil
        end
      end

      context 'when invalid number of fields for driver command' do
        before do
          @input = 'Driver'
        end

        it 'aborts continuing reading input file' do
          expect(TripService.parse_input(@input)).to be_nil
        end
      end

      context 'when invalid number of fields for trip command' do
        before do
          @input = 'Trip Mark 1.0 2.0'
        end

        it 'aborts continuing reading input file' do
          expect(TripService.parse_input(@input)).to be_nil
        end
      end

      context 'when input line is empty' do
        before do
          @input = ''
        end

        it 'returns nil' do
          expect(TripService.parse_input(@input)).to be_nil
        end
      end
    end
  end

  describe '.summary' do
    let(:driver) { model_factory.create(TripService::DRIVER, driver_name: 'Paul') }
    let(:default_trip_summary) { { driver_name: 'Paul', distance: 0, duration: 0, avg_speed: 0 } }

    context 'when trip is empty' do
      it 'returns trip summary with 0 values' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: {})
        expect(TripService.summary(driver)).to eq(default_trip_summary)
      end
    end

    context 'when trip has all zero values' do
      before do
        @trip = {
          start: '00:00',
          stop: '00:00',
          distance: '00.0'
        }
      end

      it 'returns trip summary with 0 values' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect(TripService.summary(driver)).to eq(default_trip_summary)
      end
    end

    context 'when trip stop time < start time' do
      before do
        @trip = {
          start: '01:00',
          stop: '00:00',
          distance: '100.0'
        }
      end

      it 'returns trip summary with 0 values' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect(TripService.summary(driver)).to eq(default_trip_summary)
      end
    end

    context 'when trip avg speed < 5' do
      before do
        @trip = {
          start: '00:01',
          stop: '20:01',
          distance: '80.0'
        }
      end

      it 'returns trip summary with 0 values' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect(TripService.summary(driver)).to eq(default_trip_summary)
      end
    end

    context 'when trip avg speed > 100' do
      before do
        @trip = {
          start: '01:01',
          stop: '02:01',
          distance: '110.0'
        }
      end

      it 'returns trip summary with 0 values' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect(TripService.summary(driver)).to eq(default_trip_summary)
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

      it 'returns trip summary' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip)
        expect(TripService.summary(driver)).to eq(driver_name: 'Paul', distance: 42, duration: 1.25, avg_speed: 34)
      end
    end

    context 'when two trips are made' do
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

      it 'returns trip summary' do
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip1)
        model_factory.create(TripService::TRIP, driver_name: 'Paul', trip: @trip2)
        expect(TripService.summary(driver)).to eq(driver_name: 'Paul', distance: 39, duration: 0.83, avg_speed: 47)
      end
    end
  end
end
