class CoEngine
  module Loaders
    class JsonLoader
      attr_reader :data, :engine

      def initialize(data, engine=CoEngine.new)
        @data = data
        @engine = engine
      end

      def load
        engine.state = state
        engine.current_player = current_player
        engine
      end

      #--------

      def state
        if data[:players].all? == true
          CoEngine::PlayerToPickTile
        else
          CoEngine::WaitingForPlayers
        end
      end

      def current_player
        if state != CoEngine::WaitingForPlayers
          CoEngine::Player.new(
            data[:players].first
          )
        end
      end
    end
  end
end
