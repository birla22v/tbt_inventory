require_relative './file_parser'
require_relative '../models/stock'

class InventoryAvailabilityDetector

  attr_reader :inventory_file_path, :required_inventory
  attr_accessor :remaining_inventory

  UNAVAILABLE = "buy more tuxedos".freeze
  AVAILABLE = "sufficient inventory".freeze
  RENTAL_PERIOD = 3

  def initialize(inventory_file_path:)
    @inventory_file_path = inventory_file_path
  end

  def to_buy_or_not_to_buy
    parse_file_and_store_result
    determine_availability
  end

  private
    def parse_file_and_store_result
      parser = ::FileParser.new(path: inventory_file_path)
      @required_inventory ||= parser.build_formatted_results
    end

    def remaining_inventory
      @remaining_inventory ||= Stock.all_inventory
    end

    def determine_availability
      available = true

      required_inventory.each do |day, sizes_needed_for_day|
        sizes_needed_for_day.each do |size_set|
          if !sufficient?(day, size_set)
            available = false
            break
          end
        end
      end

      available ? AVAILABLE : UNAVAILABLE
    end

    def sufficient?(start_day, sizes_needed)
      match_found = false
      possible_types = remaining_inventory[start_day].keys

      possible_types.each do |type|
        type_available_for_all_days = []
        days_garment_needed(start_day).each do |day|
          #TODO: This is not great -- it assumes a `0` inventory for any missing days.
          type_available_for_all_days << sizes_needed.all? {|size, qty| (remaining_inventory.dig(day, type, size) || 0) >= qty}
        end

        if type_available_for_all_days.all?
          match_found = true
          decrement_inventory(start_day, type, sizes_needed)
          break
        end
      end
      match_found
    end


    def days_garment_needed(day)
      #TODO: will not work properly for wrapping around time periods - ex months
      (day..(day + RENTAL_PERIOD - 1)).to_a
    end

    def decrement_inventory(start_day, type, sizes)
      days_garment_needed(start_day).each do |day|
        sizes.each do |size, qty|
          current_qty = remaining_inventory[day][type][size]
          new_qty = current_qty - qty
          remaining_inventory[day][type][size] = new_qty
        end
      end
    end
end
