class CoEngine
  class InitialTileSelection < BaseState
    class << self
      def started?
        false
      end

      def pick_tile(engine, player_id, tile_index)
        player = engine.players.detect { |p| p.id == player_id }
        raise CoEngine::TileAllocationLimitExceeded if player.tiles.count >= CoEngine::MIN_TILE_COUNT[engine.players.count]
        tile = engine.tiles[tile_index]
        raise CoEngine::TileAlreadyAllocated if tile.owner_id
        tile.assign(player)
      end

      def move_tile(engine, player_id, tile_position)
        player = engine.players.detect { |p| p.id == player_id }
        raise CoEngine::SwapPositionOutOfBounds if tile_position < 0 || tile_position >= (player.tiles.compact.count - 1)
        raise CoEngine::TilesOutOfOrder if player.tiles[tile_position] < player.tiles[tile_position + 1]
        tile = player.tiles.delete_at(tile_position)
        player.tiles.insert(tile_position + 1, tile)
      end

      def finalize_hand(engine, player_id)
        player = engine.players.detect { |p| p.id == player_id }
        raise CoEngine::UnableToFinalizeHand, 'too few tiles selected' if player.tiles.compact.count < (CoEngine::MIN_TILE_COUNT[engine.players.count] - 1)
        raise CoEngine::HandAlreadyFinalized if engine.turns.detect { |t| t[:player_id] == player_id && t[:type] == CoEngine::HAND_FINALIZED }
        engine.turns << {
          player_id: player_id,
          type: CoEngine::HAND_FINALIZED,
          state: 'completed',
        }
        engine.state = CoEngine::PlayersTurn if engine.turns.count { |t| t[:type] == CoEngine::HAND_FINALIZED } == engine.players.count
      end

      def view(engine, player_id)
        {
          state: 'InitialTileSelection',
          players: engine.players.map { |p| { id: p.id, name: p.name, tiles: tiles(p.tiles, p.id == player_id) } },
          tiles: engine.tiles.map { |t| { color: t.color, selected: !t.owner_id.nil? } }
        }
      end

      private

      def tiles(tiles, show_value)
        if show_value
          tiles.map do |t|
            {
              color: t.color,
              value: t.value || '?',
            }
          end
        else
          tiles.sort_by(&:color).map do |t|
            {
              color: t.color,
            }
          end
        end
      end
    end
  end
end
