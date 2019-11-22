require 'oystercard'
describe OysterCard do
  let(:limit) { OysterCard::LIMIT }
  let(:min_balance) { OysterCard::MINIMUM_BALANCE }
  let(:min_fare) { 1 }
  let(:station) { double :station }
  let(:station2) { double :station }
  let(:journey_log) { double :journey_log, start: nil, finish: nil, fare: 0}
  let(:journey_log_class) { double :journey_log_class, new: journey_log }
  
  subject(:card) { OysterCard.new journey_log }

  describe '#initialize' do
    it 'should initialize the class with a balance of zero' do
      expect(card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'should add given amount to balance' do
      card.top_up(10)
      expect(card.balance).to eq(10)
    end

    it 'should not push balance above limit' do
      limit.times { card.top_up 1 }
      amount = 1
      message = "Can't exceed #{limit} with #{amount}"
      expect { card.top_up amount }.to raise_error BalanceError, message
    end
  end

  describe '#touch_in' do
    it 'should raise an error if user tries to travel under minimum balance' do
      allow(journey_log).to receive(:in_journey?).and_return(false)
      message = "Insuffient funds, please top up by #{min_balance}"
      expect { card.touch_in(station) }.to raise_error JourneyError, message
    end

    context "with credit" do 
      before(:each) { card.top_up(20) }

      it "should start a journey" do 
        allow(journey_log).to receive(:in_journey?).and_return(false)
        expect(journey_log).to receive(:start).with station
        card.touch_in(station)
      end 

      it "should deduct a penalty if the previous journey wasn't complete" do 
        allow(journey).to receive(:fare).and_return(10)
        subject.touch_in(station)
        expect{ subject.touch_in(station) }.to change { subject.balance }.by -10 
      end 
    end 
  end

  describe '#touch_out' do
    before do
      card.top_up(50)
      card.touch_in(station)
      card.touch_out(station2)
    end

    it "should deduct a standard fare" do 
      card.touch_in(station)
      allow(journey).to receive(:fare).and_return(1)
      expect{ subject.touch_out(station) }.to change { subject.balance }.by -1
    end

    it "should deduct a penalty if the journey wasn't started" do 
      allow(journey).to receive(:fare).and_return(10)
      expect{ subject.touch_out(station) }.to change { subject.balance }.by -10 
    end 
  end
end
