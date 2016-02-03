require 'co_engine'

RSpec.describe CoEngine do

  describe '#perform' do
    let(:state_class) {
      Class.new(CoEngine::BaseState) do
        def self.state_method(_engine, _player_id)
          true
        end
      end
    }

    before do
      subject.state = state_class
    end

    it 'delegates the method to be called on the engines current state object' do
      expect(state_class).to receive(:state_method).with(subject, 12)
      subject.perform('state_method', 12)
    end

    it 'raises an error if the action can not be performed on the current state' do
      expect { subject.perform('unknown_method', 123) }.to raise_error(CoEngine::ActionCanNotBePerformed, 'unknown_method')
    end

    it 'can only perform valid actions' do
      expect { subject.perform('actions', 123) }.to raise_error(CoEngine::ActionCanNotBePerformed, 'actions')
    end
  end

  describe '#actions' do
    before do
      subject.current_player = double(:player, id: 123)
    end

    context 'for each given state' do
      it 'WaitingForPlayers' do
        subject.state = CoEngine::WaitingForPlayers
        expect(subject.actions(123)).to eq([:join])
      end

      it 'InitialTileSelection' do
        subject.state = CoEngine::InitialTileSelection
        expect(subject.actions(123)).to eq([:pick_tile, :move_tile, :finalize_hand])
      end

      context 'TileSelection' do
        before do
          subject.state = CoEngine::TileSelection
        end

        it 'for the current player' do
          expect(subject.actions(123)).to eq([:pick_tile])
        end

        it 'for the other players' do
          expect(subject.actions(345)).to eq([])
        end
      end
    end
  end

  def read_fixture(name)
    path = File.dirname(__FILE__)
    File.read("#{path}/fixtures/#{name}.json")
  end
end
