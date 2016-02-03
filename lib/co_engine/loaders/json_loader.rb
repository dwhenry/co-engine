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
          raise CoEngine::InvalidPlayerData, 'must be passed an array of player details'
        end
      end

      #--------

      def state
        if !players.all?
          CoEngine::WaitingForPlayers
        elsif turns.count { |t| t[:type] == CoEngine::HAND_FINALIZED } < players.count
          CoEngine::InitialTileSelection
        else
          if players.count { |p| p.tiles.any? && p.tiles.all?(&:visible) } < players.count - 1
            turn_state = turns[-1][:state]
            {
              'CoEngine::TileSelection' => CoEngine::TileSelection,
              'CoEngine::GuessTile' => CoEngine::GuessTile
            }[turn_state] || raise(CoEngine::CorruptGame, "invalid game state detected: '#{turn_state}'")
          else
            CoEngine::Completed
          end
        end
      end

      def current_player
        if state.started?
          completed_turns = turns.select{|turn| turn[:state] == CoEngine::Completed.to_s }.count

          players[completed_turns % players.count]
        end
      end

      def turns
        data[:turns] || []
      end

      def players
        @players ||= (data[:players] || []).map do |player|
          if player
            tiles = (player[:tiles] || []).map { |t| CoEngine::Tile.new(t) }
            CoEngine::Player.new(player.merge(tiles: tiles))
          end
        end
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
