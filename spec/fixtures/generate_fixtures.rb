path = File.dirname(__FILE__)

$LOAD_PATH << "#{path}/../../lib"
require 'co_engine'


game = CoEngine.load(players: [nil, nil, nil])
game.perform(:join, id: 123, name: 'john')

File.open("#{path}/one-of-three-players.json", 'w') { |f| f.puts game.export }

game.perform(:join, id: 234, name: 'bob')
game.perform(:join, id: 456, name: 'jones')

File.open("#{path}/three-of-three-players.json", 'w') { |f| f.puts game.export }
