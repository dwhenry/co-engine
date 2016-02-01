require "co_engine/version"
require "co_engine/errors"

class CoEngine

  STATES = [
    WaitingForPlayers = 'WaitingForPlayers',
    PlayerToPickTile = 'PlayerToPickTile',
  ]

  class << self
    def loader
      CoEngine::Loaders::JsonLoader
    end

    def load(data)
      loader.new(data).load
    end
  end

  attr_accessor :state,
    :players,
    :current_player,
    :turns

  def join(player)
    raise(CoEngine::GAME_FULL) if self.players.all?
    new_player = CoEngine::Player.new(player)
    raise(CoEngine::PLAYER_ALREADY_IN_GAME) if self.players.detect { |p| p == new_player }

    player_count = self.players.count
    self.players = self.players.compact + [new_player]
    self.players[player_count-1] ||= nil # ensure list of nils
  end
end
