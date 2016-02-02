require 'co_engine/loaders/json_exporter'

RSpec.describe CoEngine::Loaders::JsonExporter do
  subject { described_class.new(engine) }

  describe '#tiles' do
    let(:engine) { double(:engine) }
    let(:object) { Struct.new(:tiles).new([
      CoEngine::Tile.new(color: 'black', value: 3, owner_id: 234),
      CoEngine::Tile.new(color: 'black', value: 4, visible: true),
      CoEngine::Tile.new(color: 'white', value: 5),
      CoEngine::Tile.new(color: 'white', value: nil),
    ])}

    it 'generates the appropriate json' do
      expect(subject.tiles(object)).to eq([
        { color: "black", value: 3, owner_id: 234, visible: false },
        { color: "black", value: 4, owner_id: nil, visible: true },
        { color: "white", value: 5, owner_id: nil, visible: false },
        { color: "white", value: nil, owner_id: nil, visible: false }
      ])
    end
  end

  describe '#players' do
    let(:engine) { double(:engine, players: [
      CoEngine::Player.new(id: 234, name: 'john', tiles: [CoEngine::Tile.new(color: 'black', value: 3, owner_id: 234)]),
      nil,
      nil
    ]) }

    it 'generates the appropriate json' do
      expect(subject.players).to eq([
        { id: 234,
          name: "john",
          tiles: [{ color: "black", value: 3, owner_id: 234, visible: false }] },
        nil,
        nil
      ])
    end
  end


  describe '#turns' do
    let(:turns) { double(:turns) }
    let(:engine) { double(:engine, turns: turns) }

    it 'returns whatever is stored on the engine' do
      expect(subject.turns).to eq(turns)
    end
  end
end
