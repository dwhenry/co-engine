class CoEngine
  class BaseState
    def self.started?
      true
    end

    def self.perform(action, engine, player_id, *attr)
      is_current = actions_visible_to_all? || (engine.current_player && engine.current_player.id == player_id)
      if respond_to?(action) && actions(engine, is_current: is_current, player_id: player_id).include?(action.to_sym)
        send(action, engine, player_id, *normalize(attr))
      else
        raise(CoEngine::ActionCanNotBePerformed, action)
      end
    end

    def self.actions(engine, is_current:, player_id:)
      if is_current || actions_visible_to_all?
        (self.methods - CoEngine::BaseState.methods - [:view]).sort
      else
        []
      end
    end

    def self.actions_visible_to_all?
      true
    end

    def self.normalize(values)
      case values
      when Array
        values.map { |value| normalize(value) }
      when Hash
        values.each_with_object({}) { |(key, value), hash| hash[key.to_sym] = normalize(value) }
      else
        case values
        when values.to_i.to_s
          values.to_i
        when values.to_f.to_s
          values.to_f
        else
          values
        end
      end
    end
  end
end
