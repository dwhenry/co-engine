class CoEngine
  class TileSelection < BaseState
    END_POSITION = -1

    class << self
      def pick_tile(engine, player_id, tile_index)
        player = engine.players.detect { |p| p.id == player_id }
        tile = engine.tiles[tile_index]
        raise CoEngine::TileAlreadyAllocated if tile.owner_id
        tile.pending = true
        index = player.tiles.find_index { |t| tile < t } || END_POSITION
        player.tiles.insert(index, tile)
        tile.owner_id = player.id

        engine.state = CoEngine::GuessTile
        engine.turns[-1][:state] = CoEngine::GuessTile.to_s
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
