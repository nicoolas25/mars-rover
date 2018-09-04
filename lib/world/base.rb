module World
  class Base
    def random_position
      raise NotImplementedError
    end

    def next(from:, direction:)
      raise NotImplementedError
    end
  end
end
