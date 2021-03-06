require 'co_engine'

RSpec.describe CoEngine::Loaders::JsonLoader do
  let(:game_type) { nil }

  describe '#load' do
    subject { described_class.new(game_data.merge(game_type: game_type)) }

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

      context ', all finalized initial selection' do
        let(:game_data) { { players: [{id: 345}, {id: 567}], turns: turns } }

        context ', last turn has a state of CoEngine::TileSelection' do
          let(:turns) { [{type: CoEngine::HAND_FINALIZED}, {type: CoEngine::HAND_FINALIZED}, {state: CoEngine::TileSelection.to_s}] }

          it 'has a state of "tile selection"' do
            expect(subject.state).to eq(CoEngine::TileSelection)
          end

          it 'has a current player set to the first player' do
            player = CoEngine::Player.new(id: 345)
            expect(subject.current_player).to eq(player)
          end
        end

        context ', last turn has a state of CoEngine::GuessTile' do
          let(:turns) { [{type: CoEngine::HAND_FINALIZED}, {type: CoEngine::HAND_FINALIZED}, {state: CoEngine::GuessTile.to_s}] }

          it 'has a state of "tile selection"' do
            expect(subject.state).to eq(CoEngine::GuessTile)
          end

          it 'has a current player set to the first player' do
            player = CoEngine::Player.new(id: 345)
            expect(subject.current_player).to eq(player)
          end
        end

        context ', last turn has an invalid state' do
          let(:turns) { [{type: CoEngine::HAND_FINALIZED}, {type: CoEngine::HAND_FINALIZED}, {state: 'OtherState'}] }

          it 'has a state of "tile selection"' do
            expect { subject.state }.to raise_error(CoEngine::CorruptGame, "invalid game state detected: 'OtherState'")
          end
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
        game_data[:turns] << {state: CoEngine::Completed.to_s} << {state: CoEngine::TileSelection.to_s}
        game = described_class.new(game_data)
        expect(game.current_player).to eq(player_2)
      end

      it 'when two turn as been completed' do
        game_data[:turns] << {state: CoEngine::Completed.to_s} << {state: CoEngine::Completed.to_s} << {state: CoEngine::TileSelection.to_s}
        game = described_class.new(game_data)
        expect(game.current_player).to eq(player_1)
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

    context 'tile initialization' do
      let(:game_data) { { players: [{id: 345}, {id: 567}] } }

      context 'when game_type is not set' do
        it 'only has numbered tiles' do
          expect(subject.tiles.select { |t| t.value.nil? }).to eq([])
        end
      end

      context 'when game_type is -1' do
        let(:game_type) { -1 }

        it 'only has numbered tiles' do
          expect(subject.tiles.select { |t| t.value.nil? }).to eq([])
        end
      end

      context 'when game_type is 0' do
        let(:game_type) { 0 }

        it 'expects a black blank tile' do
          expect(subject.tiles.select { |t| t.value.nil? }).to eq([CoEngine::Tile.new(color: 'black', value: nil)])
        end
      end

      context 'when game_type is 1' do
        let(:game_type) { 1 }

        it 'expects white and black blank tiles' do
          expect(subject.tiles.select { |t| t.value.nil? }).to match_array([
            CoEngine::Tile.new(color: 'white', value: nil),
            CoEngine::Tile.new(color: 'black', value: nil),
          ])
        end

      end
    end
  end
end
