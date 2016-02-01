require 'co_engine/loaders/json_loader'

RSpec.describe CoEngine::Loaders::JsonLoader do
  describe '#load' do
    subject { described_class.new(game_data) }

    context 'loading a game without players' do
      it 'when no player data it raises an error' do
        expect { described_class.new({}).load }.to raise_error(CoEngine::INVALID_PLAYER_DATA, 'must be passed an array of player details')
      end

      it 'when empty player data it raises an error' do
        expect { described_class.new({player: []}).load }.to raise_error(CoEngine::INVALID_PLAYER_DATA, 'must be passed an array of player details')
      end
    end

    context 'newly created game' do
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

    context 'game with players' do
      let(:game_data) { { players: [{id: 345}, {id: 567}] } }

      it 'has a state of "initial tile selection"' do
        expect(subject.state).to eq(CoEngine::InitialTileSelection)
      end

      context 'and all players have tiles' do
        let(:game_data) { { players: [{id: 345, tiles: [1,2,3,4,5,6]}, {id: 567, tiles: [7,8,9,10,11,12]}] } }

        it 'has a state of "player to pick tile"' do
          expect(subject.state).to eq(CoEngine::PlayerToPickTile)
        end
      end

      it 'has a current player set to the first player' do
        player = CoEngine::Player.new(id: 345)
        expect(subject.current_player).to eq(player)
      end
    end

    context 'game with two players' do
      let(:game_data) { { players: [{id: 345}, {id: 567}], turns: [{state: 'complete'}] } }
      let(:player_1) { CoEngine::Player.new(id: 345) }
      let(:player_2) { CoEngine::Player.new(id: 567) }

      it 'when one turn as been completed' do
        game = described_class.new({ players: [{id: 345}, {id: 567}], turns: [{state: 'complete'}] })
        expect(game.current_player).to eq(player_2)
      end

      it 'when two turn as been completed' do
        game = described_class.new({ players: [{id: 345}, {id: 567}], turns: [{state: 'complete'}, {state: 'complete'}] })
        expect(game.current_player).to eq(player_1)
      end

      it 'when one turn has been completed and another is pending' do
        game = described_class.new({ players: [{id: 345}, {id: 567}], turns: [{state: 'complete'}, {state: 'guess tile'}] })
        expect(game.current_player).to eq(player_2)
      end
    end
  end
end
