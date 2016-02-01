require 'co_engine'

RSpec.describe CoEngine do
  describe '#load' do
    subject { described_class.load(game_data) }

    describe 'newly created game' do
      let(:game_data) { { id: 123, players: [nil, nil] } }

      it 'does not raise any errors' do
        expect { subject }.not_to raise_error
      end

      it 'has a state of "waiting for players"' do
        expect(subject.state).to eq(CoEngine::WaitingForPlayers)
      end
    end

    describe 'game with players' do
      let(:game_data) { { id: 123, players: [{id: 345}, {id: 567}], turns: [] } }

      it 'has a state of "player to pick tile"' do
        expect(subject.state).to eq(CoEngine::PlayerToPickTile)
      end

      it 'has a current player set to the first player' do
        player = CoEngine::Player.new(id: 345)
        expect(subject.current_player).to eq(player)
      end
    end

    describe 'game with players and turns' do
      let(:game_data) { { id: 123, players: [{id: 345}, {id: 567}], turns: [{id: 234, state: 'complete'}] } }

    end
  end
end
