require 'co_engine/loaders/json_loader'

RSpec.describe CoEngine::Loaders::JsonLoader do
  describe '#load' do
    subject { described_class.new(game_data) }

    describe 'newly created game' do
      let(:game_data) { { players: [nil, nil] } }

      it 'does not raise any errors' do
        expect { subject }.not_to raise_error
      end

      it 'has a state of "waiting for players"' do
        expect(subject.state).to eq(CoEngine::WaitingForPlayers)
      end

      it 'does not have a player' do
        expect(subject.current_player).to be_nil
      end
    end

    describe 'game with players' do
      let(:game_data) { { players: [{id: 345}, {id: 567}] } }

      it 'has a state of "player to pick tile"' do
        expect(subject.state).to eq(CoEngine::PlayerToPickTile)
      end

      it 'has a current player set to the first player' do
        player = CoEngine::Player.new(id: 345)
        expect(subject.current_player).to eq(player)
      end
    end
  end
end
