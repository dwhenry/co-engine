require 'co_engine'

RSpec.describe 'Tile creation' do
  it 'a game has tiles' do
    game = CoEngine.load(players: [nil, nil, nil])

    expect(game.tiles).not_to eq([])
  end
end
