class CoEngine
  class TileSelection < BaseState
    END_POSITION = -1
    NEXT_STATE = CoEngine::GuessTile

    class << self
      def actions_visible_to_all?
        false
      end

      def actions(engine, is_current:, player_id:)
        super - [:next_state] # this is a public, but internal method
      end

      def next_state(engine)
        if engine.tiles.any? { |t| t.owner_id.nil? }
          self
        else
          NEXT_STATE
        end
      end

      def pick_tile(engine, player_id, args)
        tile_index = args[:tile_index]
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        tile = engine.tiles[tile_index]
        raise CoEngine::TileAlreadyAllocated if tile.owner_id
        tile.pending = true
        index = engine.current_player.tiles.find_index { |t| tile < t } || END_POSITION
        engine.current_player.tiles.insert(index, tile)
        tile.owner_id = player_id

        engine.state = NEXT_STATE
        engine.turns[-1][:state] = NEXT_STATE.to_s
      end

      def view(engine, player_id)
        {
          state: 'PickTile',
          players: engine.players.map { |p| { id: p.id, name: p.name, tiles: tiles(p.tiles, p.id == player_id) } },
          current_player: engine.current_player.name,
          tiles: engine.tiles.map { |t| { color: t.color, selected: !t.owner_id.nil? } },
          guesses: engine.guesses[-[2*engine.players.count, engine.guesses.count].min..-1]
        }
      end

      private

      def tiles(tiles, show_values)
        tiles = tiles.sort_by { |t| [t.pending ? 0 : 1, t.value] } unless show_values # move pending to beginning of list

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
