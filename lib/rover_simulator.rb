class RoverSimulator

  def greeting
    "aaaaaa N\n"
  end

  def receive(command_line)
    @command_line = command_line.chomp
  end

  def answer
    "#{@command_line} aaaaaa N\n"
  end

end
