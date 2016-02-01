class CoEngine
  class Error < StandardError; end

  class INVALID_PLAYER_DATA < CoEngine::Error; end # load game without players being set
  class PLAYER_ALREADY_IN_GAME < CoEngine::Error; end
  class GAME_FULL < CoEngine::Error; end # attempting to add players to a full game
end
