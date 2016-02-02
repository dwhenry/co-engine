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
