class CoEngine
  class GuessTile < BaseState
    class << self
      def self.actions_visible_to_all?
        false
      end

      def guess(engine, player_id, guess)
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        guess_tile = engine.players.detect { |p| p.id == guess[:player_id] }.tiles[guess[:tile_position]]
        if guess_tile == CoEngine::Tile.new(color: guess[:color], value: guess[:value])
          move_state = !guess_tile.visible && player_id != guess[:player_id]
          guess_tile.visible = true

          if engine.players.count { |p| p.tiles.all?(&:visible) } < engine.players.count - 1
            if move_state
              engine.state = CoEngine::FinaliseTurnOrGuessAgain
              engine.turns[-1][:state] = CoEngine::FinaliseTurn.to_s
            end
          else
            # finalise the game
            engine.state = CoEngine::Completed
            engine.turns[-1][:state] = CoEngine::Completed.to_s
          end
        else
          pending_tile = engine.current_player.tiles.detect { |t| t.pending }
          pending_tile.visible = true

          engine.state = CoEngine::FinaliseTurn
          engine.turns[-1][:state] = CoEngine::FinaliseTurn.to_s
        end
      end

      def view(engine, player_id)
        {
          state: 'GuessTile',
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
