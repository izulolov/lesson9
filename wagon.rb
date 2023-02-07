require_relative 'manufacturer'
require 'securerandom'

class Wagon
  include Manufacturer

  SIZE_PASSENGER_MIN = 20 # Минимум 20 мест
  SIZE_PASSENGER_MAX = 120 # Максимум 120 мест

  SIZE_CARGO_MIN = 5 # Минимум 5 тонн
  SIZE_CARGO_MAX = 60 # Максимум 60 тонн

  attr_reader :type, :size, :size_occupied, :wagon_number

  def initialize(size, type)
    @size = size
    @type = type
    @size_occupied = 0
    @wagon_number = SecureRandom.hex(2).upcase
  end
end
