class RoverSimulator

  def initialize(orientation: "N")
    @orientation = orientation
    @position = "000000"
  end

  def greeting
    "#{@position} #{@orientation}\n"
  end

  def answer
    "#{@applied_commands} #{@position} #{@orientation}\n" if @applied_commands
  end

  def receive(command_line)
    @applied_commands = command_line.chomp.each_char.with_object("") do |char, memo|
      case char
      when 'f' then move_forward
      when 'b' then move_backward
      when 'l' then rotate_left
      when 'r' then rotate_right
      else raise "Unsupported #{char}"
      end
      memo << char
    end
  end

  private

  def move_forward
    @position = @position.succ
  end

  def move_backward
    @position = @position.succ
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

end
