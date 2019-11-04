require 'spec_helper'

require_relative '../../../../app/models/factory/model_factory'

describe ModelFactory do
  let(:model_factory) { ModelFactory.instance }

  after do
    model_factory.clear_all
  end

  describe '#create' do
    context 'when invalid command type' do
      it 'returns nil' do
        expect { model_factory.create('UNKNOWN', driver_name: 'John') }.to output("Invalid command type\n").to_stdout
      end
    end

    describe 'driver object' do
      context 'when creating a new driver' do
        it 'inserts one new Driver object into @@drivers collection' do
          expect(model_factory.drivers.size).to eq(0)
          expect { model_factory.create(TripService::DRIVER, driver_name: 'John') }.to change { model_factory.drivers.size }.by(1)
        end
      end

      context 'when creating two drivers with same driver name' do
        it 'inserts just one new Driver object into @@drivers collection' do
          expect(model_factory.drivers.size).to eq(0)
          expect { model_factory.create(TripService::DRIVER, driver_name: 'John') }.to change { model_factory.drivers.size }.by(1)
          expect { model_factory.create(TripService::DRIVER, driver_name: 'John') }.not_to change(model_factory.drivers, :size)
        end

        it 'returns the same object ignoring driver name case sensitivity' do
          john1 = model_factory.create(TripService::DRIVER, driver_name: 'John')
          john2 = model_factory.create(TripService::DRIVER, driver_name: 'john')
          expect(john1).to equal(john2)
        end
      end

      context 'when creating two drivers with different driver name' do
        it 'inserts just both Driver objects into @@drivers collection' do
          expect(model_factory.drivers.size).to eq(0)
          expect { model_factory.create(TripService::DRIVER, driver_name: 'John') }.to change { model_factory.drivers.size }.by(1)
          expect { model_factory.create(TripService::DRIVER, driver_name: 'Mary') }.to change { model_factory.drivers.size }.by(1)
          expect(model_factory.drivers.size).to eq(2)
        end
      end
    end

    describe 'driver_trip object' do
      before do
        @trip1 = {
          start: '00:10',
          stop: '00:40',
          distance: 3
        }
        @trip2 = {
          start: '01:10',
          stop: '01:40',
          distance: 9
        }
      end

      context 'when creating a new driver trip' do
        it 'inserts one new DriverTrip object into @@driver_trips collection' do
          expect(model_factory.driver_trips.size).to eq(0)
          expect { model_factory.create(TripService::TRIP, driver_name: 'Mary', trip: @trip1) }.to change { model_factory.driver_trips.size }.by(1)
        end
      end

      context 'when creating two driver trips with same driver name' do
        it 'inserts just one new DriverTrip object into @@drivers collection' do
          expect(model_factory.driver_trips.size).to eq(0)
          expect { model_factory.create(TripService::TRIP, driver_name: 'John', trip: @trip1) }.to change { model_factory.driver_trips.size }.by(1)
          expect { model_factory.create(TripService::TRIP, driver_name: 'John', trip: @trip2) }.not_to change(model_factory.driver_trips, :size)
        end

        it 'returns the same object ignoring driver name case sensitivity' do
          john1 = model_factory.create(TripService::TRIP, driver_name: 'John', trip: @trip1)

          expect(john1.trips.first).to equal(@trip1)
          expect(john1.trips.size).to eq(1)

          john2 = model_factory.create(TripService::TRIP, driver_name: 'john', trip: @trip2)

          expect(john1).to equal(john2)
          expect(john1.trips.size).to eq(2)
          expect(john1.trips[0]).to equal(@trip1)
          expect(john1.trips[1]).to equal(@trip2)
        end
      end

      context 'when creating two driver trips with different driver name' do
        it 'inserts just both DriverTrip objects into @@drivers collection' do
          expect(model_factory.driver_trips.size).to eq(0)
          expect { model_factory.create(TripService::TRIP, driver_name: 'John', trip: @trip1) }.to change { model_factory.driver_trips.size }.by(1)
          expect { model_factory.create(TripService::TRIP, driver_name: 'Mary', trip: @trip2) }.to change { model_factory.driver_trips.size }.by(1)
          expect(model_factory.driver_trips.size).to eq(2)
        end
      end
    end
  end

  describe '#drivers' do
    context 'when creating a driver' do
      it 'inserts a Driver object' do
        expect(model_factory.drivers.size).to eq(0)
        model_factory.create(TripService::DRIVER, driver_name: 'John')
        expect(model_factory.drivers.size).to eq(1)
      end
    end
  end

  describe '#driver_types' do
    context 'when creating a driver trip' do
      it 'inserts a DriverTrip object' do
        expect(model_factory.driver_trips.size).to eq(0)
        model_factory.create(TripService::TRIP, driver_name: 'John', trip: {})
        expect(model_factory.driver_trips.size).to eq(1)
      end
    end
  end

  describe '#clear_all' do
    it 'clears all values from @@drivers and @@driver_trips collections' do
      expect(model_factory.drivers.size).to eq(0)
      expect(model_factory.driver_trips.size).to eq(0)

      model_factory.create(TripService::DRIVER, driver_name: 'John')
      model_factory.create(TripService::TRIP, driver_name: 'John', trip: {})

      expect(model_factory.drivers.size).to eq(1)
      expect(model_factory.driver_trips.size).to eq(1)

      model_factory.clear_all

      expect(model_factory.drivers.size).to eq(0)
      expect(model_factory.driver_trips.size).to eq(0)
    end
  end
end
