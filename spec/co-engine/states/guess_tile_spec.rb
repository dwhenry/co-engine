require 'co_engine'

RSpec.describe CoEngine::GuessTile do
  let(:player_1) { CoEngine::Player.new(id: 123, tiles: [tile_3, tile_1]) }
  let(:player_2) { CoEngine::Player.new(id: 456, tiles: [tile_2, tile_4]) }
  let(:tile_1) { CoEngine::Tile.new(color: 'black', value: 8) }
  let(:tile_2) { CoEngine::Tile.new(color: 'white', value: 3) }
  let(:tile_3) { CoEngine::Tile.new(color: 'black', value: 2, pending: true) }
  let(:tile_4) { CoEngine::Tile.new(color: 'white', value: 5) }

  let(:engine) {
    Struct.new(:players, :tiles, :turns, :state, :current_player).new(
      [player_1, player_2],
      [tile_1, tile_2],
      [{player_id: player_1.id, type: CoEngine::GAME_TURN, state: described_class.to_s}],
      described_class,
      player_1) }

  subject { described_class }

  describe '#guess' do
    it 'works when numbers are passed as strings' do
      expect do
        subject.perform(:guess, engine, 123, {player_id: "456", tile_position: "0", color: 'white', value: "3"})
      end.not_to raise_error
    end

    context 'when guess is correct' do
      it 'makes the opponents tile visible' do
        subject.perform(:guess, engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 3})

        expect(tile_2.visible).to be true
      end

      it 'advances the game state' do
        subject.guess(engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 3})

        expect(engine.state).not_to eq(described_class)
      end

      context 'when all other players are out of non-visible tiles' do
        it 'finalises the game' do
          tile_4.visible = true
          subject.guess(engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 3})

          expect(engine.state).to eq(CoEngine::Completed)
        end
      end
    end

    context 'when guess is incorrect' do
      before do
        subject.guess(engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 4})
      end

      it 'makes the pending tile visible' do
        expect(tile_3.visible).to be true
      end

      it 'advances the game state' do
        expect(engine.state).not_to eq(described_class)
      end
    end

    context 'when the guess is for an already visible tile' do
      context 'and the guess is correct' do
        before do
          tile_2.visible = true
          subject.perform(:guess, engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 3})
        end

        it 'does not change the tile visibility' do
          expect(tile_2.visible).to be true
        end

        it 'does not advance the game state' do
          expect(engine.state).to eq(described_class)
        end
      end

      context 'and the guess is incorrect' do
        before do
          tile_2.visible = true
          subject.perform(:guess, engine, 123, {player_id: 456, tile_position: 0, color: 'white', value: 4})
        end

        it 'does not change the tile visibility' do
          expect(tile_2.visible).to be true
        end

        it 'makes the pending tile visible' do
          expect(tile_3.visible).to be true
        end

        it 'advances the game state' do
          expect(engine.state).not_to eq(described_class)
        end
      end
    end
  end
end
