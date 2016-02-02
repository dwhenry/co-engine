require 'co_engine/loaders/json_loader'

RSpec.describe CoEngine::Loaders::JsonLoader do
  describe '#load' do
    subject { described_class.new(game_data) }

    context 'loading a game without players' do
      it 'when no player data it raises an error' do
        expect { described_class.new({}).load }.to raise_error(CoEngine::InvalidPlayerData, 'must be passed an array of player details')
      end

      it 'when empty player data it raises an error' do
        expect { described_class.new({player: []}).load }.to raise_error(CoEngine::InvalidPlayerData, 'must be passed an array of player details')
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

      context 'and all players have finalized the initial selection' do
        let(:game_data) { { players: [{id: 345}, {id: 567}], turns: [{type: CoEngine::HAND_FINALIZED}, {type: CoEngine::HAND_FINALIZED}] } }

        it 'has a state of "player to pick tile"' do
          expect(subject.state).to eq(CoEngine::PlayersTurn)
        end

        it 'has a current player set to the first player' do
          player = CoEngine::Player.new(id: 345)
          expect(subject.current_player).to eq(player)
        end
      end

      it 'has a no current player' do
        expect(subject.current_player).to be nil
      end
    end

    context 'game with two players' do
      let(:game_data) { { players: [{id: 345}, {id: 567}], turns: [{type: CoEngine::HAND_FINALIZED}, {type: CoEngine::HAND_FINALIZED}] } }
      let(:player_1) { CoEngine::Player.new(id: 345) }
      let(:player_2) { CoEngine::Player.new(id: 567) }

      it 'when one turn as been completed' do
        game_data[:turns] << {state: 'complete'}
        game = described_class.new(game_data)
        expect(game.current_player).to eq(player_2)
      end

      it 'when two turn as been completed' do
        game_data[:turns] << {state: 'complete'} << {state: 'complete'}
        game = described_class.new(game_data)
        expect(game.current_player).to eq(player_1)
      end

      it 'when one turn has been completed and another is pending' do
        game_data[:turns] << {state: 'complete'} << {state: 'guess tile'}
        game = described_class.new(game_data)
        expect(game.current_player).to eq(player_2)
      end
    end

    context 'game with tiles' do
      let(:game_data) { { players: [{id: 345}, {id: 567}], tiles: [{color: 'black', value: 1}, {color: 'black', value: 5}] } }

      it 'reads the tile data from the array' do
        expect(subject.tiles).to eq([
          CoEngine::Tile.new(color: 'black', value: 1),
          CoEngine::Tile.new(color: 'black', value: 5),
        ])
      end
    end
  end
end
