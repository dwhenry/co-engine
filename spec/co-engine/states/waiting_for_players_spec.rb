require 'co_engine/states/base_state'
require 'co_engine/states/waiting_for_players'

RSpec.describe CoEngine::WaitingForPlayers do
  describe '#join' do
    let(:player_1) { { id: 1234, name: 'john' } }
    let(:player_2) { { id: 2345, name: 'fred' } }
    let(:player_3) { { id: 3456, name: 'bob' } }

    let(:engine) { Struct.new(:players).new([nil, nil]) }
    subject { described_class }

    it 'adds the player to the game' do
      subject.join(engine, player_1)

      expect(engine.players[0]).to eq(CoEngine::Player.new(player_1))
    end

    it 'will raise an error is attempting to add an existing player to a game' do
      subject.join(engine, player_1)
      expect { subject.join(engine, player_1) }.to raise_error(CoEngine::PLAYER_ALREADY_IN_GAME)
    end

    it 'will raise an error if game is already full' do
      subject.join(engine, player_1)
      subject.join(engine, player_2)
      expect { subject.join(engine, player_3) }.to raise_error(CoEngine::GAME_FULL)
    end
  end
end
