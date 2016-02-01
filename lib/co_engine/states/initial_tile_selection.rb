class CoEngine
  class InitialTileSelection < BaseState
    def self.started?
      false
    end

    def pick_tile(engine, player_id, tile_index)
      player = engine.players.detect { |p| p.id == player_id }
      raise CoEngine::TileAllocationLimitExceeded if player.tiles.count >= CoEngine::MIN_TILE_COUNT[engine.players.count]
      tile = engine.tiles[tile_index]
      raise CoEngine::TileAlreadyAllocated if tile.owner_id
      tile.assign(player)
    end
  end
end
