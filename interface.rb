# frozen_string_literal: true

require_relative 'interface_method'

# Класс интерфейс
class Interface
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/AbcSize
  def run
    interface_method_object = InterfaceMethod.new

    loop do
      interface_method_object.menus
      print 'Введите номер команды: '
      select = gets.chomp.to_i
      case select

      # Выход
      when 0
        puts 'До новых встреч!'
        break

      # Создать станцию
      when 1
        interface_method_object.create_stations

      # Создать поезд
      when 2
        interface_method_object.create_trains

      # Создать маршрут
      when 3
        interface_method_object.create_route

      # Создать вагон
      when 4
        interface_method_object.create_wagon

      # Добавить или удалить станцию из маршрута
      when 5
        interface_method_object.edit_route

      # Назначить маршрут поезду
      when 6
        interface_method_object.train_route

      # Добавить вагон
      when 7
        interface_method_object.add_wagon

      # Удалить вагон
      when 8
        interface_method_object.delet_wagon

      # Перемещать поезд по маршруту вперед или назад
      when 9
        interface_method_object.move_to_next_or_prev_station

      # Список станции
      when 10
        interface_method_object.list_station

      # Список поездов на станции
      when 11
        interface_method_object.trains_in_station

      # Список вагонов в поезда
      when 12
        interface_method_object.show_train_wagon

      # Выводить список поездов на станции
      when 13
        interface_method_object.show_station_train

      # Занимать место или объем в вагоне
      when 14
        interface_method_object.edit_wagon
      else
        puts 'Надо выбрать один из предложенных вариантов!'
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
end
