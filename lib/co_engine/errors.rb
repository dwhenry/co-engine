class CoEngine
  class Error < StandardError; end

  class INVALID_PLAYER_DATA < CoEngine::Error; end # load game without players being set
  class PLAYER_ALREADY_IN_GAME < CoEngine::Error; end
  class GAME_FULL < CoEngine::Error; end # attempting to add players to a full game

  class ActionCanNotBePerformed < CoEngine::Error; end # attempting to perform an action on a state that does not exist
  class TileAlreadyAllocated < CoEngine::Error; end # attempting select a tile that has already been chosen
  class TileAllocationLimitExceeded < CoEngine::Error; end # attempting to select more than allocated number of initial tiles
  class SwapPositionOutOfBounds < CoEngine::Error; end # error swapping two tiles, position out of range
  class TilesOutOfOrder < CoEngine::Error; end # error swapping two tiles, tiles are not correctly ordered
end
