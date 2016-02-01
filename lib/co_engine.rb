require "co_engine/version"

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

  attr_accessor :state, :current_player

end
