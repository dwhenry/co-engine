class CoEngine
  class BaseState
    def self.started?
      true
    end

    def self.perform(action, engine, *attr)
      if respond_to?(action)
        send(action, engine, *attr)
      else
        raise(CoEngine::ActionCanNotBePerformed, action)
      end
    end

    def self.actions
      self.methods - CoEngine::BaseState.methods
    end
  end
end
