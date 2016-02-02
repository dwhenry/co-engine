class CoEngine
  class Tile
    LARGEST_NUMBER = 100

    attr_reader :color, :value, :owner_id
    attr_accessor :visible

    def initialize(color:, value:, owner_id: nil, visible: false)
      @color = color
      @value = value
      @owner_id = owner_id
      self.visible = visible
    end

    def <(other)
      # if either is blank -> always smaller - allows it to be moved to any position
      !!value && !!other.value && (value < other.value)
    end

    def ==(other)
      color == other.color &&
        value == other.value
    end
  end
end
