class CoEngine
  class Player
    attr_accessor :id

    def initialize(attributes)
      self.id = attributes[:id]
    end

    def ==(other)
      other.is_a?(self.class) && id == other.id
    end
  end
end
