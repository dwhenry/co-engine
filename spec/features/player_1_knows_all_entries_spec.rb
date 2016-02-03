require 'co_engine'

RSpec.describe 'Player 1 know all' do
  subject { CoEngine.load(json_data) }

  context 'three player game where player 1 is on first turn in guess_tile state' do
    let(:json_data) { read_fixture('picked-game-tile') }

    it 'is a quick game' do
      subject.players.each do |player|
        next if player.id == 123

        player.tiles.each_with_index do |tile, index|
          subject.perform(:guess, 123, {player_id: player.id, tile_position: index, color: tile.color, value: tile.value})
        end
      end

      expect(subject.state).to eq(CoEngine::Completed)
      expect(subject.view(123)).to include(
        state: "Completed",
        winner: "bob"
      )

    end
  end

  def read_fixture(name)
    path = File.dirname(__FILE__)
    File.read("#{path}/../fixtures/#{name}.json")
  end

end
