class CoEngine
  class Player
    attr_accessor :id

    def initialize(attributes)
      self.id = attributes[:id]
    end

    def ==(other)
      id == other.id
    end
  end
end
