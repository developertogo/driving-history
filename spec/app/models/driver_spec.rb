require 'spec_helper'

require_relative '../../../app/models/driver'

describe Driver do
  let(:model_factory) { ModelFactory.instance }
  let(:driver) { Driver.new('Peter') }

  after do
    model_factory.clear_all
  end

  describe '#name' do
    it 'returns the driver name' do
      expect(driver.name).to eq('Peter')
    end
  end

  describe '.all' do
    it 'returns all Driver objects from ModelFactory @drivers collection' do
      expect(Driver.all.map(&:name)).not_to include('Mary')
      model_factory.create(TripService::DRIVER, driver_name: 'Mary')
      expect(Driver.all.map(&:name)).to include('Mary')
    end
  end

  describe '#trips' do
    before do
      @trip = {
        start: '07:15',
        end: '07:45',
        distance: '17.3'
      }
    end

    context 'when no trip is made' do
      it 'returns empty' do
        expect(driver.trips).to be_empty
        model_factory.create(TripService::TRIP, driver_name: 'Peter', trip: {})
        expect(driver.trips).to be_empty
      end
    end

    context 'when one trip is made' do
      it 'returns one driver trip' do
        expect(driver.trips).not_to include(@trip)
        model_factory.create(TripService::TRIP, driver_name: 'Peter', trip: @trip)
        expect(driver.trips).to include(@trip)
      end
    end

    context 'when two trips are made' do
      it 'returns two driver trips' do
        expect(driver.trips).not_to include(@trip)
        model_factory.create(TripService::TRIP, driver_name: 'Peter', trip: @trip)
        expect(driver.trips).to include(@trip)
        expect(driver.trips.size).to eq(1)

        trip = { start: '00:15', end: '05:45', distance: '180.3' }
        model_factory.create(TripService::TRIP, driver_name: 'Peter', trip: trip)
        expect(driver.trips).to include(trip)
        expect(driver.trips.size).to eq(2)
      end
    end
  end
end
