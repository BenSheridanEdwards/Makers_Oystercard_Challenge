require "oystercard"
describe OysterCard do

  describe "#initialize" do
    it "Should have money" do
      expect(subject.balance).to eq(0)
    end
  end
end