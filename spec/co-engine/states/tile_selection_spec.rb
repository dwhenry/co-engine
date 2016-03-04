require 'co_engine'

RSpec.describe CoEngine::TileSelection do
  let(:player_1) { CoEngine::Player.new(id: 123) }
  let(:player_2) { CoEngine::Player.new(id: 456) }
  let(:tile_1) { CoEngine::Tile.new(color: 'black', value: 8) }
  let(:tile_2) { CoEngine::Tile.new(color: 'white', value: 3) }
  let(:engine) {
    Struct.new(:players, :tiles, :turns, :state, :current_player).new(
      [player_1, player_2],
      [tile_1, tile_2],
      [{player_id: player_1.id, type: CoEngine::GAME_TURN, state: described_class.to_s}],
      described_class,
      player_1) }

  subject { described_class }

  describe '#next_state' do
    context 'when tiles are left to pick' do
      it 'is the current state' do
        expect(subject.next_state(engine)).to eq(described_class)
      end
    end

    context 'when no tiles are left to pick' do
      before do
        tile_1.owner_id = player_1.id
        tile_2.owner_id = player_2.id
      end

      it 'is the guess tile state' do
        expect(subject.next_state(engine)).to eq(CoEngine::GuessTile)
      end
    end

  end

  describe '#pick_tile' do

    it 'assigns the tile to the player' do
      tile_index = 1 # position in array
      subject.pick_tile(engine, player_1.id, tile_index: tile_index)
      expect(engine.players.first.tiles).to eq([tile_2])
    end

    it 'raises an error if tile has already been assigned' do
      tile_index = 1 # position in array
      subject.pick_tile(engine, player_1.id, tile_index: tile_index)

      expect { subject.pick_tile(engine, player_1.id, tile_index: tile_index) }.to raise_error(CoEngine::TileAlreadyAllocated)
    end

    it 'arranges tiles in value order regardless of selection order' do
      engine.players.first.tiles << tile_1
      subject.pick_tile(engine, player_1.id, tile_index: 1)
      expect(engine.players.first.tiles).to eq([tile_2, tile_1])
    end

    it 'marks the tile as pending - affects how other players see it' do
      expect(tile_1.pending).to be false
      subject.pick_tile(engine, player_1.id, tile_index: 0)
      expect(tile_1.pending).to be true
    end

    it 'sets the turn state to "GuessTile"' do
      subject.pick_tile(engine, player_1.id, tile_index: 0)
      expect(engine.turns[0]).to eq(
        player_id: player_1.id,
        type: CoEngine::GAME_TURN,
        state: CoEngine::GuessTile.to_s,
      )
    end

    it 'advances the game state' do
      subject.pick_tile(engine, player_1.id, tile_index: 0)

      expect(engine.state).not_to eq(described_class)
    end

    it 'raises an error if a the player attempting to take a tile is not the current player' do
      expect { subject.pick_tile(engine, player_2.id, tile_index: 0) }.to raise_error(CoEngine::NotYourTurn)
    end
  end
end
