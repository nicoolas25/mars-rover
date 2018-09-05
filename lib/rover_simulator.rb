require "world"

class RoverSimulator

  def initialize(orientation: "N", world: World::Sphere.new)
    @orientation = orientation
    @world = world
    @position = world.random_position
  end

  def greeting
    "#{@position} #{@orientation}\n"
  end

  def answer
    "#{@applied_commands} #{@position} #{@orientation}\n" if @applied_commands
  end

  def receive(command_line)
    @applied_commands = command_line.chomp.each_char.with_object("") do |char, memo|
      command_succeeded =
        case char
        when 'f' then move_forward
        when 'b' then move_backward
        when 'l' then rotate_left
        when 'r' then rotate_right
        else raise "Unsupported #{char}"
        end

      break unless command_succeeded

      memo << char
    end
  end

  private

  def move_forward
    @position = @world.next(from: @position, direction: @orientation)
  end

  def move_backward
    @position = @world.next(from: @position, direction: opposite_orientation)
  end

  def rotate_left
    @orientation =
      case @orientation
      when 'N' then 'W'
      when 'E' then 'N'
      when 'S' then 'E'
      when 'W' then 'S'
      end
  end

  def rotate_right
    @orientation =
      case @orientation
      when 'N' then 'E'
      when 'E' then 'S'
      when 'S' then 'W'
      when 'W' then 'N'
      end
  end

  def opposite_orientation
    case @orientation
    when 'N' then 'S'
    when 'E' then 'W'
    when 'S' then 'N'
    when 'W' then 'E'
    end
  end

end
