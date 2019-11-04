require 'spec_helper'

require_relative '../../../app/models/driver_trip'

describe DriverTrip do
  let(:model_factory) { ModelFactory.instance }
  let(:trip) { { start: '07:15', end: '07:45', distance: '17.3' } }
  let(:travel) { DriverTrip.new('Peter', trip) }

  after do
    model_factory.clear_all
  end

  describe '#driver_name' do
    it 'returns the driver name' do
      expect(travel.driver_name).to eq('Peter')
    end
  end

  describe '#trips' do
    before do
    end

    it 'returns the driver trips' do
      expect(travel.trips.first).to eq(trip)
    end

    context 'when trip is empty' do
      it 'returns empty' do
        sfo = DriverTrip.new('Paul', {})
        expect(sfo.trips).to be_empty
      end
    end
  end

  describe '.all' do
    it 'returns all DriverTrip objects in ModelFactory @driver_trips collection' do
      expect(DriverTrip.all.map(&:driver_name)).not_to include('Mary')
      model_factory.create(TripService::TRIP, driver_name: 'Mary', trip: trip)
      expect(DriverTrip.all.map(&:driver_name)).to include('Mary')
    end
  end
end
