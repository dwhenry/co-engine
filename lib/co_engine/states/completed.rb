class CoEngine
  class Completed < BaseState
    class << self
      def view(engine, player_id)
        {
          state: 'Completed',
          players: engine.players.map { |p| { id: p.id, name: p.name, tiles: tiles(p.tiles, p.id == player_id) } },
          winner: engine.players.detect { |p| p.tiles.any?{ |t| !t.visible } }.name,
          guesses: engine.guesses[-[2*engine.players.count, engine.guesses.count].min..-1]
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
