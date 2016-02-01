require 'co_engine/tile'

RSpec.describe CoEngine::Tile do
  describe '#<' do
    let(:black_1) { described_class.new(color: 'black', value: 1) }
    let(:black_2) { described_class.new(color: 'black', value: 2) }
    let(:black_star) { described_class.new(color: 'black', value: nil) }
    let(:white_1) { described_class.new(color: 'white', value: 1) }

    it 'is based on the value of the tile' do
      expect(black_1).to be < black_2
    end

    it 'color does not matter' do
      expect(black_1).not_to be < white_1
      expect(white_1).not_to be < black_1
    end

    it 'stars are placed at the end by default' do
      expect(black_1).to be < black_star
    end
  end
end
