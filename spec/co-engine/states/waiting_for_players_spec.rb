require 'co_engine'

RSpec.describe CoEngine::WaitingForPlayers do
  describe '#join' do
    let(:player_1) { { id: 1234, name: 'john' } }
    let(:player_2) { { id: 2345, name: 'fred' } }
    let(:player_3) { { id: 3456, name: 'bob' } }

    let(:engine) { Struct.new(:players, :state).new([nil, nil], described_class) }
    subject { described_class }

    it 'adds the player to the game' do
      subject.join(engine, player_1)

      expect(engine.players[0]).to eq(CoEngine::Player.new(player_1))
    end

    it 'will raise an error is attempting to add an existing player to a game' do
      subject.join(engine, player_1)
      expect { subject.join(engine, player_1) }.to raise_error(CoEngine::PlayerAlreadyInGame)
    end

    it 'will raise an error if game is already full' do
      subject.join(engine, player_1)
      subject.join(engine, player_2)
      expect { subject.join(engine, player_3) }.to raise_error(CoEngine::GameFull)
    end

    it 'will move to the next state once required number of players have joined' do
      subject.join(engine, player_1)
      subject.join(engine, player_2)
      expect(engine.state).not_to eq(described_class)
    end
  end
end
