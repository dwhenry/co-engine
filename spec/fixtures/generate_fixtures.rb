path = File.dirname(__FILE__)

$LOAD_PATH << "#{path}/../../lib"
require 'co_engine'

begin
  game = CoEngine.load(File.read("#{path}/one-of-three-players.json"))
rescue => e
  # raise # comment out to rebuild from scratch
  puts "Resorting to full game rebuild: #{e.message}"
  game = CoEngine.load(players: [nil, nil, nil])
  game.perform(:join, id: 123, name: 'john')
end

File.open("#{path}/one-of-three-players.json", 'w') { |f| f.puts game.export(pretty: true) }

game.perform(:join, id: 234, name: 'bob')
game.perform(:join, id: 456, name: 'jones')

File.open("#{path}/three-of-three-players.json", 'w') { |f| f.puts game.export(pretty: true) }

game.perform(:pick_tile, 123, 4)
game.perform(:pick_tile, 123, 5)
game.perform(:pick_tile, 123, 7)
game.perform(:pick_tile, 123, 9)

game.perform(:pick_tile, 234, 6)
game.perform(:pick_tile, 234, 8)
game.perform(:pick_tile, 234, 10)
game.perform(:pick_tile, 234, 12)

game.perform(:pick_tile, 456, 0)
game.perform(:pick_tile, 456, 1)
game.perform(:pick_tile, 456, 2)
game.perform(:pick_tile, 456, 3)

File.open("#{path}/all-selected-tiles-without-finalizing.json", 'w') { |f| f.puts game.export(pretty: true) }

game.perform(:finalize_hand, 123)
game.perform(:finalize_hand, 234)
game.perform(:finalize_hand, 456)

File.open("#{path}/finalized-starting-tiles.json", 'w') { |f| f.puts game.export(pretty: true) }

game.perform(:pick_tile, 123, 14)

File.open("#{path}/picked-game-tile.json", 'w') { |f| f.puts game.export(pretty: true) }
