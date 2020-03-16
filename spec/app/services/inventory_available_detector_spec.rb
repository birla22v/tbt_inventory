require 'rspec'
require_relative '../../../app/services/inventory_availability_detector'

describe InventoryAvailabilityDetector do
  context 'when the inventory requested is greater than inventory available for any style' do
    it 'should return unavailable' do
      path = 'spec/sample_input/fail0.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::UNAVAILABLE
    end
  end

  context 'when the inventory for a given day would be unavailable due to previous bookings' do
    it 'should return unavailable' do
      path = 'spec/sample_input/fail1.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::UNAVAILABLE
    end
  end

  context 'when inventory requested is within total requested inventory but it would have to split styles' do
    it 'should return unavailable' do
      path = 'spec/sample_input/fail2.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::UNAVAILABLE
    end
  end

  context 'when information about the next day is missing' do
    it 'should return unavailable' do
      path = 'spec/sample_input/fail3.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::UNAVAILABLE
    end
  end

  context 'when inventory is available for the day and subsequent days (single event)' do
    it 'should return available' do
      path = 'spec/sample_input/success0.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::AVAILABLE
    end
  end

  context 'when inventory is available for the day and subsequent days (multiple events)' do
    it 'should return available' do
      path = 'spec/sample_input/success1.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::AVAILABLE
    end
  end

  context 'when inventory is available frees up after rental period' do
    it 'should return available' do
      path = 'spec/sample_input/success2.txt'
      service = InventoryAvailabilityDetector.new(inventory_file_path: path)

      expect(service.to_buy_or_not_to_buy).to eq InventoryAvailabilityDetector::AVAILABLE
    end
  end
end
