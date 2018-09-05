require "world/base"

class FakeWorld < World::Sphere
  def initialize(random_position: "049049")
    super(size: 100)
    @random_position = random_position
  end

  def random_position
    @random_position
  end
end
