class CoEngine
  class FinaliseTurnOrGuessAgain < CoEngine::FinaliseTurn
    class << self
      def actions_visible_to_all?
        false
      end

      def guess(engine, player_id, guess)
        raise CoEngine::NotYourTurn if engine.current_player.id != player_id
        guess_tile = engine.players.detect { |p| p.id == guess[:player_id] }.tiles[guess[:tile_position]]
        if guess_tile == CoEngine::Tile.new(color: guess[:color], value: guess[:value])
          guess_tile.visible = true

          unless engine.players.count { |p| p.tiles.all?(&:visible) } < engine.players.count - 1
            # finalise the game
            engine.state = CoEngine::Completed
            engine.turns[-1][:state] = CoEngine::Completed.to_s
          end
        else
          pending_tile = engine.current_player.tiles.detect { |t| t.pending }
          pending_tile.visible = true

          engine.state = CoEngine::FinaliseTurn
          engine.turns[-1][:state] = CoEngine::FinaliseTurn.to_s
        end
      end

      private

      def state
        'GuessTileOrFinalize'
      end
    end
  end
end
