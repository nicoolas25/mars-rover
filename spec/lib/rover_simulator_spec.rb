require "rover_simulator"

RSpec.describe RoverSimulator do
  let(:instance) { described_class.new }

  describe "#greeting" do
    subject(:greeting) { instance.greeting }

    it "always ends with: '\\n'" do
      is_expected.to be_end_with("\n")
    end

    it "returns a position and orientation" do
      is_expected.to match /^[a-f0-9]{6} [NSEW]\n$/
    end
  end

  describe "#answer" do
    subject(:answer) { instance.answer }

    context "when no command has been received" do
      it { is_expected.to be_nil }
    end

    context "when a command has been received" do
      before { instance.receive(received_command) }

      let(:received_command) { random_command }

      it "starts with the received command" do
        is_expected.to be_start_with(received_command.chomp)
      end
    end
  end

  describe "#receive" do
    subject(:receive) { instance.receive(command_line) }

    let!(:initial_position) { components(instance.greeting).first }
    let!(:initial_orientation) { components(instance.greeting).last }

    context "when the command is 'f\\n' or 'b\\n'" do
      let(:command_line) { ["b\n", "f\n"].sample }

      it "keeps the same orientation" do
        receive
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq initial_orientation
      end

      it "goes into on a different position" do
        receive
        _, position, _ = components(instance.answer)
        expect(position).not_to eq initial_position
      end
    end

    context "when the command is 'l\\n' or 'r\\n'" do
      let(:command_line) { ["r\n", "l\n"].sample }

      it "keeps the same position" do
        receive
        _, position, _ = components(instance.answer)
        expect(position).to eq initial_position
      end

      it "changes orientation" do
        receive
        _, _, orientation = components(instance.answer)
        expect(orientation).not_to eq initial_orientation
      end
    end

    describe "the way orientation behave" do
      let(:instance) { described_class.new(orientation: "N") }

      it "rotates right four time to be oriented N again (ESWN)" do
        instance.receive("r\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "E"

        instance.receive("r\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "S"

        instance.receive("r\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "W"

        instance.receive("r\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "N"
      end

      it "rotates left four time to be oriented N again (WSEN)" do
        instance.receive("l\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "W"

        instance.receive("l\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "S"

        instance.receive("l\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "E"

        instance.receive("l\n")
        _, _, orientation = components(instance.answer)
        expect(orientation).to eq "N"
      end
    end

    describe "the way position works" do
      [
        "fffrfffrfffrfff\n",
        "ffflffflffflfff\n",
        "bbblbbblbbblbbb\n",
        "bbbrbbbrbbbrbbb\n",
      ].each do |square_command|
        context "when doing a square" do
          let(:command_line) { square_command }

          it "comes back its original position" do
            receive
            _, position, _ = components(instance.answer)
            expect(position).to eq initial_position
          end
        end
      end
    end
  end

  def components(answer)
    answer.chomp.split(" ") if answer
  end

  def random_command(size: random_command_size)
    possible_commands = %w[f b l r]
    possible_commands.sample(size).join + "\n"
  end

  def random_command_size
    rand(10) + 1
  end
end
