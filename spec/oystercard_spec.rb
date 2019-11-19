require "oystercard"
describe OysterCard do

  let(:card) {OysterCard.new}
  let(:limit) { OysterCard::LIMIT } 
  let(:min_balance) { OysterCard::MINIMUM_BALANCE }

  describe "#initialize" do
    it "should initialize the class with a balance of zero" do
      expect(card.balance).to eq(0)
    end
  end

  describe "#top_up" do
    it "should add given amount to balance" do
      card.top_up(10)
      expect(card.balance).to eq(10)
    end

    it "Should not push balance above limit" do
      limit.times { card.top_up 1 }
      amount = 1
      message = "Can't exceed #{limit} with #{amount}"
      expect{ card.top_up amount }.to raise_error BalanceError, message
    end
  end

  describe "#deduct" do
    it "should deduct a specified fare,then return the remaining balance" do
      card.top_up(30)
      expect(card.deduct(10)).to eq(20)
    end
  end

  describe "#touch_in" do


    it "should change the in_journey status to true" do
      card.top_up(50)
      card.touch_in
      expect(card.in_journey).to be_truthy
    end
    
    it "should raise an error if user tries to travel under minimum balance" do
      message = "Insuffient funds, please top up by minimum balance #{min_balance}"
      expect { card.touch_in }.to raise_error JourneyError, message
    end

  end

  describe "#touch_out" do
    it "should change in_journey status to false" do
      card.top_up(50)
      card.touch_in
      card.touch_out
      expect(card.in_journey).to be_falsey
    end
  end
end

