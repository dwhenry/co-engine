class CoEngine
  class InitialTileSelection < BaseState
    def self.started?
      false
    end

    def self.pick_tile(engine, player_id, tile_index)
      player = engine.players.detect { |p| p.id == player_id }
      raise CoEngine::TileAllocationLimitExceeded if player.tiles.count >= CoEngine::MIN_TILE_COUNT[engine.players.count]
      tile = engine.tiles[tile_index]
      raise CoEngine::TileAlreadyAllocated if tile.owner_id
      tile.assign(player)
    end

    def self.move_tile(engine, player_id, tile_position)
      player = engine.players.detect { |p| p.id == player_id }
      raise CoEngine::SwapPositionOutOfBounds if tile_position < 0 || tile_position >= (player.tiles.compact.count - 1)
      raise CoEngine::TilesOutOfOrder if player.tiles[tile_position] < player.tiles[tile_position + 1]
      tile = player.tiles.delete_at(tile_position)
      player.tiles.insert(tile_position + 1, tile)
    end
  end
end
