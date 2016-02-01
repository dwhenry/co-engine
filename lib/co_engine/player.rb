class CoEngine
  class Player
    attr_accessor :id, :tiles

    def initialize(attributes)
      self.id = attributes[:id]
      self.tiles = attributes[:tiles] || []
    end

    def ==(other)
      other.is_a?(self.class) && id == other.id
    end
  end
end
