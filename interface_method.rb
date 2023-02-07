require_relative 'train'
require_relative 'train_passenger'
require_relative 'train_cargo'
require_relative 'route'
require_relative 'station'
require_relative 'wagon'
require_relative 'wagon_passenger'
require_relative 'wagon_cargo'

class InterfaceMethod
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end
  WAGON_TYPES = { 'Cargo' => WagonCargo, 'Passenger' => WagonPassenger }.freeze
  # Создать меню
  def menus
    puts 'Выберите команду:'
    puts %(    0. Выход
    1. Создать станцию    2. Создать поезд    3. Создать маршрут    4. Создать вагон
    5. Добавлять или удалять станцию    6. Назначать маршрут поезду
    7. Добавлять вагоны к поезду    8. Отцеплять вагоны от поезда
    9. Перемещать поезд по маршруту вперед или назад    10. Просматривать список станций
    11. Cписок поездов на станции    12. Выводить список вагонов у поезда
    13. Выводить список поездов на станции    14. Занимать место или объем в вагоне)
  end

  # Создать станцию
  def create_stations
    puts 'Введите название станции'
    name = gets.chomp
    @stations << Station.new(name)
    puts "Создана станция #{name}" if @stations[-1].valid?
  end

  # Создать поезд
  # rubocop:disable Metrics/AbcSize
  def create_trains
    attempt = 0
    begin
      puts 'С каким номер создать поезд? Формат: 3 буквы/цифры, необ-ный дефис и еще 2 буквы/цифры. Например: РУС-05'
      number = gets.chomp
      puts '1 - пассажирский, 2 - грузовой'
      select = gets.chomp.to_i
      case select
      when 1
        @trains << TrainPassenger.new(number)
        puts "Создан пассажирский поезд с номером: #{number}" if @trains[-1].valid?
      when 2
        @trains << TrainCargo.new(number)
        puts "Создан грузовой поезд с номером: #{number}" if @trains[-1].valid?
      else
        puts 'Поезд не создан! Введите 1 чтобы создать пассажирский, 2 для грузогого'
      end
    rescue StandardError
      puts 'Вы ввели неправильные данные для создания поезда! Попробуйте еще раз.'
      attempt += 1
      retry if attempt <= 3
    end
  end

  # Создать маршрут
  # rubocop:disable Metrics/PerceivedComplexity
  def create_route
    if @stations.length < 2
      puts 'Чтобы создать маршрут нужно создать хотябы две станции'
    else
      puts %(Какой маршрут создать?
      Начальную и конечную станцию в маршруте можете выбрать из списка ниже.
      Для этого введите название станции:)
      @stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
      print 'Введите название начальной станции:'
      name1 = gets.chomp
      st1 = @stations.detect { |name| name.name == name1 }
      print 'Введите название конечной станции:'
      name2 = gets.chomp
      st2 = @stations.detect { |name| name.name == name2 }
      if st1.nil? || st2.nil?
        puts 'Ошибка! Проверьте правильно ли ввели название станции. Попробуйте заново.'
      else
        @routes << Route.new(st1, st2)
        puts "Создан маршрут #{st1.name} - #{st2.name}"
      end
    end
  end

  # Создать вагон
  def create_wagon
    puts 'какой вагон создать? 1 - Пассажирский 2 - Грузовой'
    choise = gets.chomp.to_i
    case choise
    when 1
      puts 'Введите кол-во мест в вагоне (от 20 до 120)'
      seats = gets.chomp.to_i
      if seats >= Wagon::SIZE_PASSENGER_MIN && seats <= Wagon::SIZE_PASSENGER_MAX
        wagon = WagonPassenger.new(seats)
        @wagons << wagon
        puts "Создан вагон #{wagon.wagon_number} - #{wagon.size} - #{wagon.type}"
      else
        puts 'Не правильно ввели кол-во мест в вагоне! Попробуйте еще раз.'
      end
    when 2
      puts 'Введите объем вагона (от 5 до 60 тонн)'
      volume = gets.chomp.to_i
      if volume >= Wagon::SIZE_CARGO_MIN && volume <= Wagon::SIZE_CARGO_MAX
        wagon = WagonCargo.new(volume)
        @wagons << wagon
        puts "Создан вагон #{wagon.wagon_number} - #{wagon.size} - #{wagon.type}"
      else
        puts 'Не правильно ввели кол-во мест в вагоне! Попробуйте еще раз.'
      end
    end
  end

  # Редактировать маршрут
  # rubocop:disable Metrics/CyclomaticComplexity
  def edit_route
    if !@routes.empty?
      puts 'Выберите маршрут из списка ниже которую хотите редактировать (добавить/удалить станцию)'
      @routes.each_with_index { |route, index| puts "#{index + 1} -> #{route.from.name} - #{route.to.name}" }
      rt = gets.chomp.to_i
      if rt.between?(1, @routes.length)
        puts "Вы выбрали маршрут #{@routes[rt - 1].from.name} - #{@routes[rt - 1].to.name}"
        puts 'Введите 1 чтобы добавить станцию, 2 - удалить'
        select = gets.chomp.to_i
        case select
        when 1
          puts 'Доступны следующие станции для добавления. Введите название станции из списка.'
          @stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
          name = gets.chomp
          st = @stations.detect { |station| station.name == name }
          # rubocop:disable Metrics/BlockNesting
          if !st.nil?
            @routes[rt - 1].add_station(st)
            puts "Добавлена станция: #{st.name}"
          else
            puts "Ошибка! Не нашли станцию #{name}. Попробуйте заново"
          end
        when 2
          puts 'Какую станцию удалить? Введите название станции. Выберите из списка ниже:'
          @routes[rt - 1].show_stations
          name = gets.chomp
          st = @stations.detect { |station| station.name == name }
          if !st.nil?
            @routes[rt - 1].delete_station(st)
          else
            puts "Ошибка! Не нашли станцию #{name} для удаления. Попробуйте заново."
          end
        else
          puts 'Маршрут остался без изменения! Надо было выбрать 1 или 2'
        end
      else
        puts 'Ошибка! Неправильно ввели индекс маршрута. Попробуйте заново.'
      end
    else
      puts 'Сначала надо создать маршрут!'
    end
  end

  # Задать маршрут поезду
  def train_route
    if @trains.empty?
      puts 'Сначала надо создать поезд'
    elsif @routes.empty?
      puts 'Сначала надо создать маршрут'
    else
      puts 'Выберите в какой маршрут хотите назначить поезд(введите индекс):'
      @routes.each_with_index { |route, index| puts "#{index + 1} -> #{route.from.name} - #{route.to.name}" }
      rt = gets.chomp.to_i
      if rt.between?(1, @routes.length)
        puts "Выберите какой поезд назначить на маршрут: #{@routes[rt - 1].from.name} - #{@routes[rt - 1].to.name} (введите номер поезда):"
        @trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number}" }
        number = gets.chomp
        tr = @trains.detect { |train| train.number == number }
        if !tr.nil?
          tr.take_route(@routes[rt - 1])
        else
          puts 'Ошибка! Неправильно выбрали индекс поезда!. Попробуйте еще раз'
        end
      else
        puts "Ошибка! Не нашли маршрут с индексом #{rt}. Попробуйте еще раз."
      end
    end
  end

  # Добавить вагон
  def add_wagon
    if @trains.empty?
      puts 'Сначала необходимо создать поезд'
    else
      puts 'К какому поезду добваить вагон? (введите номер)'
      number = gets.chomp
      train = @trains.detect { |tr| tr.number == number }
      if train.nil?
        puts 'Поезда с таким номером нет'
      elsif train.speed.zero?
        puts 'Какой вагон хотите прицепить к поезду? Введите номер вагона'
        number_wagon = gets.chomp
        wagon = @wagons.detect { |wg| wg.wagon_number == number_wagon }
        if wagon.nil?
          puts 'Вагон с таким номером не удалось найти!'
        else
          train.add_wagon(wagon)
        end
      else
        puts 'Находу нельзя добавить вагон к поезду'
      end
    end
  end

  # Удалить вагон
  def delet_wagon
    if @trains.empty?
      puts 'Сначала необходимо создать поезд'
    else
      puts 'От какого поезда оцепить вагон? (введите номер)'
      number = gets.chomp
      train = @trains.detect { |tr| tr.number == number }
      if train.nil?
        puts 'Поезда с таким номером нет'
      elsif train.all_wagon.empty?
        puts 'У этого поезда и так нет вагонов'
      elsif !train.speed.zero?
        puts 'Находу нельзя удалить вагоны!'
      else
        train.remove_wagon
      end
    end
  end

  # Перемещать поезд по маршруту вперед или назад
  def move_to_next_or_prev_station
    puts 'Какими поездами вы можете двигать(то есть каким поездам назначено станция):'
    @stations.each_index do |index|
      @stations[index].trains.each do |train|
        puts "На станции #{@stations[index].name} - поезд с номером № #{train.number}"
      end
    end
    puts 'Какой поезд хотите двигать? (введите номер)'
    number = gets.chomp
    train = @trains.detect { |tr| tr.number == number }
    if train.nil?
      puts 'Поезда с таким номером нет'
    else
      puts 'Выбрите 1 для впред, 2 для назад'
      move = gets.chomp.to_i
      case move
      when 1 # Вперед
        train.move_to_next_station
        puts "На станцию #{@stations[train.station_index].name} прибыль поезд с номером #{train.number}"
      when 2 # Назад
        train.move_to_prev_station
        puts "На станцию #{@stations[train.station_index].name} прибыль поезд с номером #{train.number}"
      else
        puts 'Надо было выбрать 1 или 2'
      end
    end
  end

  # Список станции
  def list_station
    if @stations.empty?
      puts 'Сначала надо создать станцию!'
    else
      puts 'Все станции:'
      @stations.each { |station| puts station.name }
    end
  end

  # Поезда на станции
  def trains_in_station
    if @stations.empty?
      puts 'Сначала надо создать станцию!'
    else
      puts 'На какой станции?:'
      name = gets.chomp
      station = @stations.detect { |st| st.name == name }
      if station.nil?
        puts 'Такой станции нет'
      elsif station.trains.length.positive?
        station.trains_in_station
      else
        puts "На станции #{station.name} поездов нет!"
      end
    end
  end

  # Выводить список вагонов у поезда
  def show_train_wagon
    puts 'Вагоны какого поезда хотите посмотрет? Введите номер поезда'
    number = gets.chomp
    train = @trains.detect { |tr| tr.number == number }
    if train.nil?
      puts 'Не нашли поезд с таким номером!'
    else
      train.block_wagon_in_train(train) do |wg|
        puts "#{wg.wagon_number} - #{wg.type} - #{wg.free_volume} - #{wg.volume_occupied}"
      end
    end
  end

  # Выводить список поездов на станции
  def show_station_train
    puts 'Поезда какой станции хотите посмотреть? Введите название поезда'
    name = gets.chomp
    station = @stations.detect { |st| st.name == name }
    if station.nil?
      puts 'Не нашли поезд с таким названием'
    else
      station.block_train_in_station(station) { |tr| puts "#{tr.number} - #{tr.type} - #{tr.wagon_count}" }
    end
  end

  # Рекдактировать вагон
  def edit_wagon
    puts 'Введите номер вагона для того, чтобы занят место/объем в вагоне'
    number = gets.chomp
    wagon = @wagons.detect { |wg| wg.wagon_number == number }
    if wagon.nil?
      puts 'Не удалось найти вагон с таким номером! Попробуйте еще раз.'
    else
      puts "№#{wagon.wagon_number} - #{wagon.type} - #{wagon.free_volume} - #{wagon.volume_occupied}"
      if wagon.type == 'Cargo'
        puts 'Сколько объем(тонн) хотите занимать?'
        volume = gets.chomp.to_i
        wagon.take_volume(volume)
        puts "Добавили #{volume} к вагону #{wagon.wagon_number}"
        puts "№#{wagon.wagon_number} - #{wagon.type} - #{wagon.free_volume} - #{wagon.volume_occupied}"
      else
        puts 'В пассажирском поезде место можно занимать по подну за раз.'
        puts 'Введите 1 для того, чтобы занимать место, 0 для того чтобы выйти.'
        loop do
          place = gets.chomp
          if place == '1'
            wagon.take_volume
            puts "Заняли одно место в вагоне #{wagon.wagon_number}"
            puts "№#{wagon.wagon_number} - #{wagon.type} - #{wagon.free_volume} - #{wagon.volume_occupied}"
          else
            break if place == '0'

            puts 'Надо было ввести 0 или 1'
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/BlockNesting
end
