require 'json'

require "co_engine/version"
require "co_engine/errors"

require "co_engine/loaders/json_exporter"
require "co_engine/loaders/json_loader"

require "co_engine/player"
require "co_engine/tile"


require "co_engine/states/base_state"
require "co_engine/states/waiting_for_players"
require "co_engine/states/initial_tile_selection"

require "co_engine/states/tile_selection"
require "co_engine/states/guess_tile"
require "co_engine/states/finalise_turn"

require "co_engine/states/completed"

class CoEngine

  GAME_STATES = [
    WaitingForPlayers,
    InitialTileSelection,
    TileSelection,
    GuessTile,
    FinaliseTurn,
    Completed,
  ]

  TURN_TYPES = [
    HAND_FINALIZED = 'HAND_FINALIZED',
    GAME_TURN = 'GAME_TURN',
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

    def exporter
      CoEngine::Loaders::JsonExporter
    end

    def load(data)
      loader.new(data).load
    end
  end

  attr_accessor :state,
    :players,
    :current_player,
    :turns,
    :tiles

  def actions
    state.actions
  end

  def perform(action, *attr)
    state.perform(action, self, *attr)
  end

  def export
    self.class.exporter.new(self).export
  end

  def view(player_id)
    state.view(self, player_id)
  end
end
