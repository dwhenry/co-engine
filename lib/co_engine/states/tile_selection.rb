class CoEngine
  class TileSelection < BaseState
    END_POSITION = -1

    class << self
      def pick_tile(engine, player_id, tile_index)
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        tile = engine.tiles[tile_index]
        raise CoEngine::TileAlreadyAllocated if tile.owner_id
        tile.pending = true
        index = engine.current_player.tiles.find_index { |t| tile < t } || END_POSITION
        engine.current_player.tiles.insert(index, tile)
        tile.owner_id = player_id

        engine.state = CoEngine::GuessTile
        engine.turns[-1][:state] = CoEngine::GuessTile.to_s
      end

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
        tiles = tiles.sort_by(&:pending) unless show_values

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
