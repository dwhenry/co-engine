require "co_engine/version"

class CoEngine

  STATES = [
    WaitingForPlayers = 'WaitingForPlayers',
    PlayerToPickTile = 'PlayerToPickTile',
  ]

  class << self
    def load(data)
      engine = self.new
      if data[:players].all? == true
        engine.state = CoEngine::PlayerToPickTile
        engine.current_player = CoEngine::Player.new(data[:players].first)
      else
        engine.state = CoEngine::WaitingForPlayers
      end
      engine
    end
  end

  attr_accessor :state, :current_player

end
