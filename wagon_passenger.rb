require_relative 'wagon'
class WagonPassenger < Wagon
  def initialize(size)
    super(size, 'Passenger')
  end

  # Добавить метод, который "занимает места" в вагоне (по одному за раз)
  def take_volume
    take_place!
  end

  # Добавить метод, который возвращает кол-во занятых мест в вагоне
  def volume_occupied
    @size_occupied
  end

  # Добавить метод, возвращающий кол-во свободных мест в вагоне.
  def free_volume
    size - @size_occupied
  end

  private

  def take_place!
    @size_occupied += 1 if size - @size_occupied >= 0
  end
end
