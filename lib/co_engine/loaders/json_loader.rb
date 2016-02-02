class CoEngine
  module Loaders
    class JsonLoader
      attr_reader :data, :engine

      def initialize(data, engine=CoEngine.new)
        @data = data.is_a?(Hash) ? data : JSON.parse(data, symbolize_names: true)
        @engine = engine
      end

      def load
        validate!
        engine.state = state
        engine.players = players
        engine.current_player = current_player
        engine.turns = turns
        engine.tiles = tiles
        engine
      end

      def validate!
        if data[:players].nil? || data[:players].empty?
          raise CoEngine::INVALID_PLAYER_DATA, 'must be passed an array of player details'
        end
      end

      #--------

      def state
        if !players.all? == true
          CoEngine::WaitingForPlayers
        elsif players.any? { |p| p.tiles.count < CoEngine::MIN_TILE_COUNT[players.count] }
          CoEngine::InitialTileSelection
        else
          CoEngine::PlayerToPickTile
        end
      end

      def current_player
        if state.started?
          completed_turns = turns.select{|turn| turn[:state] == 'complete' }.count

          players[completed_turns % players.count]
        end
      end

      def turns
        data[:turns] || []
      end

      def players
        @players ||= (data[:players] || []).map { |player| player && CoEngine::Player.new(player) }
      end

      def tiles
        if data[:tiles]
          data[:tiles].map do |tile|
            CoEngine::Tile.new(tile)
          end
        else
          %w{black white}.flat_map do |color|
            (0..9).map do |value|
              CoEngine::Tile.new(color: color, value: value)
            end
          end.shuffle
        end
      end
    end
  end
end
