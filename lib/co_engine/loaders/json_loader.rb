class CoEngine
  module Loaders
    class JsonLoader
      attr_reader :data, :engine

      def initialize(data, engine=CoEngine.new)
        @data = data
        @engine = engine
      end

      def load
        validate!
        engine.state = state
        engine.players = players
        engine.current_player = current_player
        engine.turns = turns
        engine
      end

      def validate!
        if data[:players].nil? || data[:players].empty?
          raise CoEngine::INVALID_PLAYER_DATA, 'must be passed an array of player details'
        end
      end

      #--------

      def state
        if players.all? == true
          CoEngine::PlayerToPickTile
        else
          CoEngine::WaitingForPlayers
        end
      end

      def current_player
        if state != CoEngine::WaitingForPlayers
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
    end
  end
end
