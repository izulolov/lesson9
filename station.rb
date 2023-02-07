require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  NAME_FORMAT = /^[а-яё\s]{3,}$/i.freeze

  # rubocop:disable Style/ClassVars
  # Создаем массив класса
  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << name
    register_instance
  end

  # rubocop:enable Style/ClassVars
  # написать метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок
  def block_train_in_station(station, &block)
    block_given? ? station.trains.each(&block) : (puts 'Этот метод может принимать блок. Попробуйте еще раз!')
  end

  # Может принимать поезда (по одному за раз)
  def get_train(train)
    get_train!(train)
  end

  # Может отправлять поезда(по одному за раз, поезда удаляются из списка)
  def send_train(train)
    send_train!(train)
  end

  # Проверка является ли объект класса Station валидным или нет
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def trains_in_station
    puts "На станции #{name} в данный момент находятся след поезда:"
    trains.each { |train| puts " #{train.number} - #{train.type} - #{train.wagon_count}" }
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def trains_type_in_station(type)
    puts "Поезда на станции #{name} типа #{type}: "
    trains.select { |train| train.type == type }
  end

  # Метод отдающий кол-во по типу
  def count_trains_by(type)
    puts "Кол-во поездов типа #{type}: #{trains.count { |x| x.type == type }}"
  end

  private

  # Валидация название станции
  def validate!
    raise 'Название станции должно состоять хотябы из 3-х букв русского алфавита' if @name.length < 3
    raise 'Название станции должно состоять только из букв русского алфавита' if @name !~ NAME_FORMAT
  end

  def get_train!(train)
    @trains << train
  end

  def send_train!(train)
    @trains.delete(train)
  end
end
