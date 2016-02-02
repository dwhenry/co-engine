require 'co_engine/tile'

RSpec.describe CoEngine::Tile do
  let(:black_1) { described_class.new(color: 'black', value: 1) }
  let(:black_2) { described_class.new(color: 'black', value: 2) }
  let(:black_blank) { described_class.new(color: 'black', value: nil) }
  let(:white_1) { described_class.new(color: 'white', value: 1) }

  describe '#<' do
    it 'is based on the value of the tile' do
      expect(black_1).to be < black_2
    end

    it 'color does not matter' do
      expect(black_1).not_to be < white_1
      expect(white_1).not_to be < black_1
    end

    it 'blank tiles are small than nothing - results in them being placed at start of tiles' do
      expect(black_blank).not_to be < black_1
      expect(black_1).not_to be < black_blank
      expect(black_blank).not_to be < black_blank
    end
  end

  describe '#new' do
    it 'can be built from an option hash' do
      options = { color: 'black', value: 12 }
      expect { CoEngine::Tile.new(options) }.not_to raise_error
    end
  end
end
