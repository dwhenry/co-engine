class CoEngine
  class WaitingForPlayers < BaseState
    def self.started?
      false
    end

    def self.join(game, player)
      raise(CoEngine::GAME_FULL) if game.players.all?
      new_player = CoEngine::Player.new(player)
      raise(CoEngine::PLAYER_ALREADY_IN_GAME) if game.players.detect { |p| new_player == p }
      game.players[game.players.index(nil)] = new_player
    end
  end
end
