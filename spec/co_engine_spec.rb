require 'co_engine'

RSpec.describe CoEngine do
  let(:state_class) {
    Class.new(CoEngine::BaseState) do
      def self.state_method(_engine, _params)
        true
      end
    end
  }

  before do
    subject.state = state_class
  end

  describe '#view' do
    let(:engine) { CoEngine.load(json_data) }
    let(:view) { engine.view(123) }

    context 'waiting for players' do
      let(:json_data) { read_fixture('one-of-three-players') }

      it 'shows current and pending player names' do
        expect(view).to eq(
          state: 'WaitingForPlayers',
          players: [{id: 123, name: 'john'}, {id: nil, name: 'pending'}, {id: nil, name: 'pending'}]
        )
      end
    end

    context 'initial tiles selection' do
      context 'before any tiles are selected' do
        let(:json_data) { read_fixture('three-of-three-players') }

        it 'lists players and has a full list of selectable tiles' do

          expect(view).to include(
            state: 'InitialTileSelection',
            players: [{id: 123, name: 'john', tiles: []}, {id: 234, name: 'bob', tiles: []}, {id: 456, name: 'jones', tiles: []}]
          )

          # this assume simple game without blank tokens -> howis this set??
          tiles = view[:tiles]
          expect(tiles.count).to eq(20)
          expect(tiles.count { |t| t[:selected] }).to eq(0)
          expect(tiles.count { |t| t[:color] == 'black' }).to eq(10)
          expect(tiles[0].keys).to eq([:color, :selected])
        end
      end

      context 'after tiles are selected - before finalisation' do
        let(:json_data) { read_fixture('all-selected-tiles-without-finalizing') }

        it 'tiles for the requesting player have a value while other players dont' do
          player_1, player_2, player_3 = *view[:players]

          expect(player_1[:tiles].count).to eq(4)
          expect(player_1[:tiles].all? { |t| t[:value] }).to be true

          expect(player_2[:tiles].count).to eq(4)
          expect(player_2[:tiles].none? { |t| t[:value] }).to be true
          expect(player_3[:tiles].count).to eq(4)
          expect(player_3[:tiles].none? { |t| t[:value] }).to be true
        end

        it 'has marked selected tiles as taken' do
          tiles = view[:tiles]
          expect(tiles.count { |t| t[:selected] }).to eq(12)
        end
      end
    end
  end

  describe '#perform' do
    it 'delegates the method to be called on the engines current state object' do
      expect(state_class).to receive(:state_method).with(subject, {id: 12, message: 'hi'})
      subject.perform('state_method', {id: 12, message: 'hi'})
    end

    it 'raises an error if the action can not be performed on the current state' do
      expect { subject.perform('unknown_method', {id: 12, message: 'hi'}) }.to raise_error(CoEngine::ActionCanNotBePerformed, 'unknown_method')
    end
  end

  describe '#actions' do
    it 'returns a list of valid actions for the current state' do
      expect(subject.actions).to eq([:state_method])
    end

    context 'for each given state' do
      it 'WaitingForPlayers' do
        subject.state = CoEngine::WaitingForPlayers
        expect(subject.actions).to eq([:join, :view])
      end

      it 'InitialTileSelection' do
        subject.state = CoEngine::InitialTileSelection
        expect(subject.actions).to eq([:pick_tile, :move_tile, :finalize_hand, :view])
      end
    end
  end

  def read_fixture(name)
    path = File.dirname(__FILE__)
    File.read("#{path}/fixtures/#{name}.json")
  end
end
