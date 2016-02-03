class CoEngine
  class FinaliseTurn < BaseState
    class << self
      # def move_tile(engine, player_id, tile_position)
      #   player = engine.players.detect { |p| p.id == player_id }
      #   raise CoEngine::SwapPositionOutOfBounds if tile_position < 0 || tile_position >= (player.tiles.compact.count - 1)
      #   raise CoEngine::TilesOutOfOrder if player.tiles[tile_position] < player.tiles[tile_position + 1]
      #   tile = player.tiles.delete_at(tile_position)
      #   player.tiles.insert(tile_position + 1, tile)
      # end
      #
      # def finalize_hand(engine, player_id)
      #   player = engine.players.detect { |p| p.id == player_id }
      #   raise CoEngine::UnableToFinalizeHand, 'too few tiles selected' if player.tiles.compact.count < (CoEngine::MIN_TILE_COUNT[engine.players.count] - 1)
      #   raise CoEngine::HandAlreadyFinalized if engine.turns.detect { |t| t[:player_id] == player_id && t[:type] == CoEngine::HAND_FINALIZED }
      #   engine.turns << {
      #     player_id: player_id,
      #     type: CoEngine::HAND_FINALIZED,
      #     state: 'completed',
      #   }
      #   if engine.turns.count { |t| t[:type] == CoEngine::HAND_FINALIZED } == engine.players.count
      #     engine.state = CoEngine::TileSelection
      #     engine.turns << {
      #       player_id: engine.players[0],
      #       type: CoEngine::GAME_TURN,
      #       state: CoEngine::TileSelection.to_s,
      #     }
      #   end
      # end

      # def guess(engine, player_id, guess)
      #   raise CoEngine::NotYourTurn if engine.current_player.id != player_id
      #   guess_tile = engine.players.detect { |p| p.id == guess[:player_id] }.tiles[guess[:tile_position]]
      #   if guess_tile == CoEngine.new(guess.slice(:color, :value))
      #     guess_tile.visible = true
      #     game.state = CoEngine::FinaliseTurn
      #   else
      #
      #   end
      # end

      def view(engine, player_id)
        {
          state: 'PickTile',
          players: engine.players.map { |p| { id: p.id, name: p.name, tiles: tiles(p.tiles, p.id == player_id) } },
          current_player_position: engine.players.index(engine.current_player),
          tiles: engine.tiles.map { |t| { color: t.color, selected: !t.owner_id.nil? } }
        }
      end

      private

      def tiles(tiles, show_values)
        tiles = tiles.sort_by{ |t| t.pending ? 0 : 1 } unless show_values # move pending to beginning of list

        tiles.map do |t|
          r = { color: t.color }
          r[:value] = t.value || '?' if show_values || t.visible
          r[:pending] = true  if t.pending
          r
        end
      end
    end
  end
end
