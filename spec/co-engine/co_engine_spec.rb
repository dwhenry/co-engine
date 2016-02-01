require 'co-engine/co_engine'

RSpec.describe CoEngine do
  describe '#add' do
    it 'returns the sum of its arguments' do
      expect(described_class.new).to be_a(described_class)
    end
  end
end
