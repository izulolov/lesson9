require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'station'
require_relative 'validation'
class Route
  include InstanceCounter
  include Validation
  extend Accessors
  
  validate :stations, :presence
  # rubocop:disable Layout/EmptyLinesAroundAttributeAccessor
  attr_reader :stations
  # Проверка attr_accessor_with_history, можер работать с любим количеством атрибутов.
  # В конце атрибут :to убрал чтобы на нем проверить работу strong_attr_accessor
  attr_accessor_with_history :from #, :to
  strong_attr_accessor :to, Station # :to это по сути объект класса Station поэтому как второй параметр отдали класс Station
  def initialize(from, to)
    @from = from
    @to = to
    @stations = [from, to]
    validate!
    register_instance
  end

  #def valid?
  #  validate!
  #  true
  #rescue StandardError
  #  false
  #end

  # Может добавлять промежуточную станцию в список
  def add_station(station)
    add_station!(station)
  end

  # Может удалять промежуточную станцию из списка
  def delete_station(station)
    delete_station!(station)
  end

  # Может выводить список всех станций по-порядку от начальной до конечной
  def show_stations
    puts "В маршрут #{stations.first.name} - #{stations.last.name} входят станции: "
    stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
  end

  private

  # Валидация маршрута
  # rubocop:disable Metrics/AbcSize
  #def validate!
  #  raise 'Первая и последняя станция не должны совпадать' if from.name == to.name
  #  raise 'Не выбранно первая и последняя станция' if stations[0].nil? && stations[1].nil?
  #  raise 'Не выбранно первая или последняя станция' if stations[0].nil? || stations[1].nil?
  #end

  # Может добавлять промежуточную станцию в список
  def add_station!(station)
    stations.insert(1, station)
  end

  # Может удалять промежуточную станцию из списка
  def delete_station!(station)
    stations.delete(station)
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Layout/EmptyLinesAroundAttributeAccessor
end
