require 'co_engine'

RSpec.describe CoEngine do
  describe '#perform' do
    let(:state_class) {
      Class.new(CoEngine::BaseState) do
        def state_method(engine, params)
          true
        end
      end
    }

    before do
      subject.state = state_class
    end
    it 'delegates the method to be called on the engines current state object' do
      expect(state_class).to receive(:state_method).with(subject, {id: 12, message: 'hi'})
      subject.perform('state_method', {id: 12, message: 'hi'})
    end

    it 'raises an error if the action can not be performed on the current state' do
      expect { subject.perform('unknown_method', {id: 12, message: 'hi'}) }.to raise_error(CoEngine::ActionCanNotBePerformed, 'unknown_method')
    end
  end
end
