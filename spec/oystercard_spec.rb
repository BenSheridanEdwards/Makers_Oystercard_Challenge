require 'oystercard'
describe OysterCard do
  let(:limit) { OysterCard::LIMIT }
  let(:min_balance) { OysterCard::MINIMUM_BALANCE }
  let(:min_fare) { 1 }
  let(:station) { double :station }
  let(:station2) { double :station }
  let(:journey) { double :journey, start: nil, finish: nil, fare: 0}
  let(:journey_class) { double :journey_class, new: journey }

  subject(:card) { OysterCard.new journey_class }

  describe '#initialize' do
    it 'should initialize the class with a balance of zero' do
      expect(card.balance).to eq(0)
    end

    it 'should initialze with an empty journey array' do
      expect(card.journey_list).to eq []
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
      message = "Insuffient funds, please top up by #{min_balance}"
      expect { card.touch_in(station) }.to raise_error JourneyError, message
    end

    context "with credit" do 
      before(:each) { card.top_up(20) }

      it "should start a journey" do 
        expect(journey).to receive(:start).with station
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
    it 'should change in_journey status to false' do
      expect(card.in_journey?).to be_falsey
    end

    it 'should accept an argument of the exit station, and store it' do
      expect(card.journey_list[0]).to eq(journey)
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
