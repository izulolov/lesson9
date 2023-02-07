# frozen_string_literal: true

# Service to download ftp files from the server
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  # Методы класса
  module ClassMethods
    def instances
      @instances ||= 0
    end
  end

  # Инстанс методы
  module InstanceMethods
    protected

    def register_instance
      self.class.instaces += 1
    end
  end
end
