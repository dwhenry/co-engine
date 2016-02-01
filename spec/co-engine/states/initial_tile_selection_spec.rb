require 'co_engine/states/base_state'
require 'co_engine/states/initial_tile_selection'
require 'co_engine/player'
require 'co_engine/tile'

RSpec.describe CoEngine::InitialTileSelection do
  describe '#pick_tile' do
    let(:player_1) { CoEngine::Player.new(id: 123) }
    let(:player_2) { CoEngine::Player.new(id: 456) }
    let(:tile_1) { CoEngine::Tile.new(color: 'black', value: 8) }
    let(:tile_2) { CoEngine::Tile.new(color: 'white', value: 3) }
    let(:engine) { Struct.new(:players, :tiles).new([player_1, player_2], [tile_1, tile_2]) }

    it 'assigns the tile to the player' do
      tile_index = 1 # position in array
      subject.pick_tile(engine, player_1.id, tile_index)
      expect(engine.players.first.tiles).to eq([tile_2])
    end

    it 'raises an error if tile has already been assigned' do
      tile_index = 1 # position in array
      subject.pick_tile(engine, player_1.id, tile_index)

      expect { subject.pick_tile(engine, player_1.id, tile_index) }.to raise_error(CoEngine::TileAlreadyAllocated)
    end

    it 'raises an error if the user has already reached the initial tile limit' do
      player_1.tiles << 1 << 2 << 3 << 4 << 5 << 6
      tile_index = 1 # position in array

      expect { subject.pick_tile(engine, player_1.id, tile_index) }.to raise_error(CoEngine::TileAllocationLimitExceeded)
    end

    it 'arranges tiles in value order regardless of selection order' do
      subject.pick_tile(engine, player_1.id, 0)
      subject.pick_tile(engine, player_1.id, 1)
      expect(engine.players.first.tiles).to eq([tile_2, tile_1])
    end
  end
end
