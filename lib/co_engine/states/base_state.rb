class CoEngine
  class BaseState
    def self.started?
      true
    end

    def self.perform(action, engine, player_id, *attr)
      is_current = actions_visible_to_all? || (engine.current_player && engine.current_player.id == player_id)
      if respond_to?(action) && actions(is_current: is_current).include?(action.to_sym)
        send(action, engine, player_id, *attr)
      else
        raise(CoEngine::ActionCanNotBePerformed, action)
      end
    end

    def self.actions(is_current:)
      if is_current || actions_visible_to_all?
        self.methods - CoEngine::BaseState.methods - [:view]
      else
        []
      end
    end

    def self.actions_visible_to_all?
      true
    end
  end
end
