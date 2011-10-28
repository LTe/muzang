module DrugBot
  class Engine
    def add_periodic_timer(time, &block)
      raise NoImplementError
    end

    def add_timer(time, &block)
      raise NoImplementError
    end

    def execute(operation, callback)
      raise NoImplementError
    end
  end
end
