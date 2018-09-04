module World
  class Sphere < Base
    def initialize(size: 100)
      @size = size
    end

    def random_position
      format(x: rand(@size), y: rand(@size))
    end

    def next(from:, direction:)
      x, y = unpack(from)
      case direction
      when 'N' then y = decrease(y)
      when 'E' then x = increase(x)
      when 'S' then y = increase(y)
      when 'W' then x = decrease(x)
      else raise "Unsupported direction #{direction}"
      end
      format(x: x, y: y)
    end

    private

    def format(x:, y:)
      "%03d%03d" % [x, y]
    end

    def unpack(formatted_postion)
      match_data = formatted_postion.match(/(?<x>\d\d\d)(?<y>\d\d\d)/)
      [match_data[:x].to_i, match_data[:y].to_i]
    end

    def increase(value)
      if value + 1 >= @size
        0
      else
        value + 1
      end
    end

    def decrease(value)
      if (value - 1) < 0
        @size
      else
        value - 1
      end
    end
  end
end
