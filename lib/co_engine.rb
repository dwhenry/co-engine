require "co_engine/version"
require "co_engine/errors"

require "co_engine/states/base_state"
require "co_engine/states/waiting_for_players"
require "co_engine/states/initial_tile_selection"
require "co_engine/states/player_to_pick_tile"

class CoEngine

  STATES = [
    WaitingForPlayers,
    InitialTileSelection,
    PlayerToPickTile,
  ]

  MIN_TILE_COUNT = {
    2 => 6,
    3 => 4,
    4 => 3,
    5 => 2,
    6 => 2,
  }


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
    raise(CoEngine::PLAYER_ALREADY_IN_GAME) if self.players.detect { |p| new_player == p }
    self.players[self.players.index(nil)] = new_player
  end
end
