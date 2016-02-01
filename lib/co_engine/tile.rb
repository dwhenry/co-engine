class CoEngine
  class Tile
    LARGEST_NUMBER = 100

    attr_reader :color, :value, :owner_id

    def initialize(color:, value:, owner_id: nil)
      @color = color
      @value = value
      @owner_id = owner_id
    end

    def assign(player)
      index = player.tiles.find_index { |t| self < t } || 0
      player.tiles.insert(index, self)
      @owner_id = player.id
    end

    def <(other)
      # nil or star is treated as the larges number
      (value || LARGEST_NUMBER) < (other.value || LARGEST_NUMBER)
    end
  end
end
