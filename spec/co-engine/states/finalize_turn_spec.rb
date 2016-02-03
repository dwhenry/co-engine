require 'co_engine'

RSpec.describe CoEngine::FinaliseTurn do
  let(:player_1) { CoEngine::Player.new(id: 123, tiles: [tile_5, tile_1, tile_3]) }
  let(:player_2) { CoEngine::Player.new(id: 456, tiles: [tile_2, tile_4]) }
  let(:tile_1) { CoEngine::Tile.new(color: 'black', value: 8) }
  let(:tile_2) { CoEngine::Tile.new(color: 'white', value: 3) }
  let(:tile_3) { CoEngine::Tile.new(color: 'white', value: 8, pending: true) }
  let(:tile_4) { CoEngine::Tile.new(color: 'white', value: 5) }
  let(:tile_5) { CoEngine::Tile.new(color: 'black', value: 3) }

  let(:engine) {
    Struct.new(:players, :tiles, :turns, :state, :current_player).new(
      [player_1, player_2],
      [tile_1, tile_2],
      [{player_id: player_1.id, type: CoEngine::GAME_TURN, state: described_class.to_s}],
      described_class,
      player_1) }

  subject { described_class }

  describe '#move_tile' do
    it 'raises an error unless current player' do
      expect { subject.move_tile(engine, player_2.id, 0) }.to raise_error(CoEngine::NotYourTurn)
    end

    it 'allows adjacent tiles to be swapped' do
      subject.move_tile(engine, player_1.id, 1)
      expect(player_1.tiles).to eq([tile_5, tile_3, tile_1])
    end

    it 'raises if attempting to swap tiles with an out of bounds index' do
      expect { subject.move_tile(engine, player_1.id, -1) }.to raise_error(CoEngine::SwapPositionOutOfBounds)
      expect { subject.move_tile(engine, player_1.id, player_1.tiles.count-1) }.to raise_error(CoEngine::SwapPositionOutOfBounds)
    end

    it 'raise an error if swapping tiles breaks ordering requirements' do
      expect { subject.move_tile(engine, player_1.id, 0) }.to raise_error(CoEngine::TilesOutOfOrder)
    end

    it 'allows blank tiles to be swapped with any other tile' do
      tile_blank = CoEngine::Tile.new(color: 'black', value: nil)

      player_1.tiles << tile_blank

      subject.move_tile(engine, player_1.id, 2)
      subject.move_tile(engine, player_1.id, 1)
      subject.move_tile(engine, player_1.id, 0)
      expect(player_1.tiles).to eq([tile_blank, tile_5, tile_1, tile_3])
    end
  end

  describe '#finalize_hand' do
    it 'raises an error unless current player' do
      expect { subject.finalize_hand(engine, player_2.id) }.to raise_error(CoEngine::NotYourTurn)
    end

    it 'sets the state of the current turn to completed' do
      current_turn = engine.turns[-1]

      subject.finalize_hand(engine, player_1.id)

      expect(current_turn[:state]).to eq(CoEngine::Completed.to_s)
    end

    it 'updates the current player to the next player in the array' do
      subject.finalize_hand(engine, player_1.id)

      expect(engine.current_player).to eq(player_2)
    end

    it 'loops around the current player when it hits the last player in list' do
      engine.turns.insert(-2, {state: CoEngine::Completed.to_s})
      engine.current_player = player_2

      subject.finalize_hand(engine, player_2.id)

      expect(engine.current_player).to eq(player_1)
    end

    it 'creates a new turn for the next player' do
      expect { subject.finalize_hand(engine, player_1.id) }.to change { engine.turns.count }.by(1)

      expect(engine.turns[-1]).to eq(
        player_id: player_2.id,
        state: "CoEngine::TileSelection",
        type: "GAME_TURN",
      )
    end

    it 'removes the pending status from any tile for the current player' do
      subject.finalize_hand(engine, player_1.id)
      expect(player_1.tiles.select { |t| t.pending }.count).to eq 0
    end
  end
end
