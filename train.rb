require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :wagon_count, :number, :type, :route, :all_wagon, :station_index

  NUMBER_FORMAT = /^[а-яё|\d]{3}(-)*[а-яё|\d]{2}$/i.freeze

  # rubocop:disable Style/ClassVars
  @@all_trains = []

  def self.find(num)
    @@all_trains.detect { |tr| tr.number == num }
  end

  def initialize(number, type)
    @number = number
    @type = type
    validate!
    @all_wagon = []
    @wagon_count = 0
    @speed = 0
    @route = nil
    @station_index = nil
    @@all_trains << self
    register_instance
  end

  # rubocop:enable Style/ClassVars
  # Написать метод, который принимает блок и проходит по всем вагонам поезда, передавая каждый объект вагона в блок.
  def block_wagon_in_train(train, &block)
    block_given? ? train.all_wagon.each(&block) : (puts 'Этот метод может принимать блок. Попробуйте еще раз!')
  end

  # Проверка является ли поезд валидным
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def stop
    stop!
  end

  # Может прицеплять вагоны
  def add_wagon(wagon)
    add_wagon!(wagon)
  end

  # Может отцеплять вагоны
  def remove_wagon
    remove_wagon!
  end

  # Может принимать маршрут следования (объект класса Route).
  def take_route(route)
    take_route!(route)
  end

  # Текущая станция
  def current_station
    current_station!
  end

  # Следующая станция
  def next_station
    next_station!
  end

  # Предедущая станция
  def prev_station
    prev_station!
  end

  # Вперед
  def move_to_next_station
    move_to_next_station!
  end

  # Назад
  def move_to_prev_station
    move_to_prev_station!
  end

  private

  # Валидация номера поезда
  def validate!
    raise 'Неверный формат номера поезда!' if @number !~ NUMBER_FORMAT
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def stop!
    @speed = 0
  end

  # Может прицеплять вагоны
  def add_wagon!(wagon)
    @wagon_count += 1
    all_wagon.push(wagon)
  end

  # Может отцеплять вагоны
  def remove_wagon!
    @wagon_count -= 1
  end

  # Может принимать маршрут следования (объект класса Route).
  def take_route!(route)
    @route = route
    @station_index = 0
    current_station.get_train(self)
  end

  # Текущая станция
  def current_station!
    @route.stations[@station_index]
  end

  # Следующая станция
  def next_station!
    @route.stations[@station_index + 1]
  end

  # Предедущая станция
  def prev_station!
    @route.stations[@station_index - 1]
  end

  # Вперед
  def move_to_next_station!
    current_station.send_train(self)
    @station_index += 1
    current_station.get_train(self)
  end

  # Назад
  def move_to_prev_station!
    current_station.send_train(self)
    @station_index -= 1
    current_station.get_train(self)
  end
end
