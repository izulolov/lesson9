module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :checks

    # Содержит метод класса validate. Этот метод принимает в качестве параметров имя проверяемого атрибута,
    # а также тип валидации и при необходимости дополнительные параметры. Возможные типы валидаций: presence, format, type
    def validate(*args)
      args ||= []
      @checks  ||= []
      checks << args
    end
  end

  module InstanceMethods
    #Содержит инстанс-метод validate!, который запускает все проверки (валидации), указанные в классе
    #через метод класса validate. В случае ошибки валидации выбрасывает исключение с сообщением о том,
    #какая именно валидация не прошла
    def validate!
      self.class.checks.each { |val| self.send val[1].to_sym, instance_variable_get("@#{val[0]}".to_sym), val[2] }
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def presence(value, _choice)
      raise "Значение #{value} не может быть nil или пустой" if value.empty? || value.nil?
    end

    def format(value, choice)
      raise "Неверный формат у #{value}!" if value !~ choice
    end

    def type(value, choice)
      raise "Классы не соотвествуют! #{value.class} != #{choice}" if instance_of?(choice)
    end
  end
end
