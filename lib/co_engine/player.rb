class CoEngine
  class Player
    attr_accessor :id, :name, :tiles

    def initialize(id:, name: "Player-#{Time.now.to_i}", tiles:[])
      self.id = id
      self.name = name
      self.tiles = tiles
    end

    def ==(other)
      other.is_a?(self.class) && id == other.id
    end
  end
end
