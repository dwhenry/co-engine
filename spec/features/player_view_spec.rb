require 'co_engine'

RSpec.describe CoEngine do
  subject { CoEngine.load(json_data) }

  describe '#view' do

    context 'waiting for players' do
      let(:json_data) { read_fixture('one-of-three-players') }

      it 'shows current and pending player names' do
        expect(subject.view(123)).to eq(
          state: 'WaitingForPlayers',
          players: [{id: 123, name: 'john'}, {id: nil, name: 'pending'}, {id: nil, name: 'pending'}]
        )
      end
    end

    context 'initial tiles selection' do
      context 'before any tiles are selected' do
        let(:json_data) { read_fixture('three-of-three-players') }

        it 'lists players and has a full list of selectable tiles' do

          expect(subject.view(123)).to include(
            state: 'InitialTileSelection',
            players: [{id: 123, name: 'john', tiles: []}, {id: 234, name: 'bob', tiles: []}, {id: 456, name: 'jones', tiles: []}]
          )

          # this assume simple game without blank tokens -> howis this set??
          tiles = subject.view(123)[:tiles]
          expect(tiles.count).to eq(20)
          expect(tiles.count { |t| t[:selected] }).to eq(0)
          expect(tiles.count { |t| t[:color] == 'black' }).to eq(10)
          expect(tiles[0].keys).to eq([:color, :selected])
        end
      end

      context 'after tiles are selected - before finalisation' do
        let(:json_data) { read_fixture('all-selected-tiles-without-finalizing') }

        it 'tiles for the requesting player have a value while other players dont' do
          players = subject.view(123)[:players]
          player_1, player_2, player_3 = *players

          expect(player_1[:tiles].count).to eq(4)
          expect(player_1[:tiles].all? { |t| t[:value] }).to be true

          expect(player_2[:tiles].count).to eq(4)
          expect(player_2[:tiles].none? { |t| t[:value] }).to be true
          expect(player_3[:tiles].count).to eq(4)
          expect(player_3[:tiles].none? { |t| t[:value] }).to be true
        end

        it 'has marked selected tiles as taken' do
          tiles = subject.view(123)[:tiles]
          expect(tiles.count { |t| t[:selected] }).to eq(12)
        end
      end
    end
  end

  def read_fixture(name)
    path = File.dirname(__FILE__)
    File.read("#{path}/../fixtures/#{name}.json")
  end
end
