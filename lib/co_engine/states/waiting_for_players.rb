class CoEngine
  class WaitingForPlayers < BaseState
    def self.started?
      false
    end

    def self.join(engine, player_id, attributes)
      raise(CoEngine::GameFull) if engine.players.all?
      new_player = CoEngine::Player.new(attributes.merge(id: player_id))
      raise(CoEngine::PlayerAlreadyInGame) if engine.players.detect { |p| new_player == p }
      engine.players[engine.players.index(nil)] = new_player

      engine.state = CoEngine::InitialTileSelection if engine.players.all?
    end

    def self.view(engine, _player_id)
      {
        state: 'WaitingForPlayers',
        players: engine.players.map { |p| { id: p && p.id, name: p ? p.name : 'pending' } }
      }
    end
  end
end
