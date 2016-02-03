class CoEngine
  class GuessTile < BaseState
    class << self
      
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
