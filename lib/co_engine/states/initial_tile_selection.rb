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

    def self.finalize_hand(engine, player_id)
      player = engine.players.detect { |p| p.id == player_id }
      raise CoEngine::UnableToFinalizeHand, 'too few tiles selected' if player.tiles.compact.count < (CoEngine::MIN_TILE_COUNT[engine.players.count] - 1)
      raise CoEngine::HandAlreadyFinalized if engine.turns.detect { |t| t[:player_id] == player_id && t[:type] == CoEngine::HAND_FINALIZED }
      engine.turns << {
        player_id: player_id,
        type: CoEngine::HAND_FINALIZED,
        state: 'completed',
      }
      engine.state = CoEngine::PlayerToPickTile if engine.turns.count { |t| t[:type] == CoEngine::HAND_FINALIZED } == engine.players.count
    end
  end
end
