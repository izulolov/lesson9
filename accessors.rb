module Accessors
  # Метод attr_accessor_with_history
  # Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов,
  # при этом сеттер сохраняет все значения инстанс-переменной при изменении этого значения.
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        @history ||= {}
        @history[name] ||= []
        @history[name] << value
      end
      # Также в класс, в который подключается модуль должен добавляться инстанс-метод <имя_атрибута>_history
      # который возвращает массив всех значений данной переменной.
      define_method("#{name}_history") { @history ? @history[name] : [] }
    end
  end

  # Метод strong_attr_accessor
  # Принимает имя атрибута и его класс. При этом создается геттер и сеттер для одноименной инстанс-переменной,
  # но сеттер проверяет тип присваемоего значения. Если тип отличается от того, который указан вторым параметром,
  # то выбрасывается исключение. Если тип совпадает, то значение присваивается.
  def strong_attr_accessor(name, arg_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise 'Ошибка! Неверный тип переменной.' if value.class != arg_class

      instance_variable_set(var_name, value)
    end
  end
end
