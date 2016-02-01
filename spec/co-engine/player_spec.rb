require 'co_engine/player'

RSpec.describe CoEngine::Player do
  describe '#==' do
    let(:player_1) { described_class.new(id: 123) }
    let(:player_2) { described_class.new(id: 123) }
    let(:player_3) { described_class.new(id: 456) }

    it 'matches based on ID' do
      expect(player_1).to eq(player_2)
      expect(player_1).not_to eq(player_3)
    end
  end
end
