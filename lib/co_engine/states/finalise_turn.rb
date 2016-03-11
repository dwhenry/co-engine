class CoEngine
  class FinaliseTurn < BaseState
    class << self
      def actions_visible_to_all?
        false
      end

      def move_tile(engine, player_id, args)
        tile_position = args[:tile_position]
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        raise CoEngine::SwapPositionOutOfBounds if tile_position < 0 || tile_position >= (engine.current_player.tiles.count - 1)
        raise CoEngine::TilesOutOfOrder if engine.current_player.tiles[tile_position] < engine.current_player.tiles[tile_position + 1]
        tile = engine.current_player.tiles.delete_at(tile_position)
        engine.current_player.tiles.insert(tile_position + 1, tile)
      end

      def finalize_hand(engine, player_id)
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        engine.turns[-1][:state] = CoEngine::Completed.to_s
        engine.current_player.tiles.each { |t| t.pending = false }

        while true do
          completed_turns = engine.turns.select{ |turn| turn[:state] == CoEngine::Completed.to_s }.count
          engine.current_player = engine.players[completed_turns % engine.players.count]

          engine.turns << {
            player_id: engine.current_player.id,
            type: CoEngine::GAME_TURN,
            state: CoEngine::TileSelection.next_state(engine).to_s,
          }
          break if engine.current_player.tiles.any? { |t| !t.visible }
          engine.turns[-1][:type] = CoEngine::SKIPPED
          engine.turns[-1][:state] = CoEngine::Completed.to_s
        end
      end

      def view(engine, player_id)
        {
          state: state,
          players: engine.players.map { |p| { id: p.id, name: p.name, tiles: tiles(p.tiles, p.id == player_id) } },
          current_player: engine.current_player.name,
          tiles: engine.tiles.map { |t| { color: t.color, selected: !t.owner_id.nil? } },
          guesses: engine.guesses[-[2*engine.players.count, engine.guesses.count].min..-1]
        }
      end

      private

      def state
        'Finalize'
      end

      def tiles(tiles, show_values)
        tiles = tiles.sort_by { |t| [t.pending ? 0 : 1, t.value] } unless show_values # move pending to beginning of list

        tiles.map do |t|
          r = { color: t.color, visible: t.visible }
          r[:value] = t.value || '?' if show_values || t.visible
          r[:pending] = true  if t.pending
          r
        end
      end
    end
  end
end
