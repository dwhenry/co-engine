class CoEngine
  module Loaders
    class JsonExporter
      attr_reader :engine

      def initialize(engine)
        @engine = engine
      end

      def export(pretty: false)
        data = {
          players: players,
          tiles: tiles(engine),
          turns: turns
        }
        pretty ? JSON.pretty_unparse(data) : data.to_json
      end

      def turns
        engine.turns
      end

      def players
        engine.players.map do |player|
          player && {
            id: player.id,
            name: player.name,
            tiles: tiles(player)
          }
        end
      end

      def tiles(obj)
        obj.tiles.map do |tile|
          {
            color: tile.color,
            value: tile.value,
            owner_id: tile.owner_id,
            visible: tile.visible,
            pending: tile.pending,
          }
        end
      end
    end
  end
end
