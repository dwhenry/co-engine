class CoEngine
  class Error < StandardError; end

  # Waiting for players
  class InvalidPlayerData < CoEngine::Error; end # load game without players being set
  class PlayerAlreadyInGame < CoEngine::Error; end
  class GameFull < CoEngine::Error; end # attempting to add players to a full game

  # Initial Tile Selection
  class ActionCanNotBePerformed < CoEngine::Error; end # attempting to perform an action on a state that does not exist
  class TileAlreadyAllocated < CoEngine::Error; end # attempting select a tile that has already been chosen
  class TileAllocationLimitExceeded < CoEngine::Error; end # attempting to select more than allocated number of initial tiles

  # Tile movement and finalization
  class SwapPositionOutOfBounds < CoEngine::Error; end # error swapping two tiles, position out of range
  class TilesOutOfOrder < CoEngine::Error; end # error swapping two tiles, tiles are not correctly ordered
  class UnableToFinalizeHand < CoEngine::Error; end # too few tiles selected
  class HandAlreadyFinalized < CoEngine::Error; end
end
