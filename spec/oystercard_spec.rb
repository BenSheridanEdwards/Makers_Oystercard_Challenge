require "oystercard"
describe OysterCard do

  describe "#initialize" do
    it "should initialize the class with a balance of zero" do
      expect(subject.balance).to eq(0)
    end
  end
end