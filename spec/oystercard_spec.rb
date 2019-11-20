require 'oystercard'
describe OysterCard do
  let(:card) { OysterCard.new }
  let(:limit) { OysterCard::LIMIT }
  let(:min_balance) { OysterCard::MINIMUM_BALANCE }
  let(:min_fare) { OysterCard::MINIMUM_FARE }
  let(:station) { double :station }
  let(:station2) { double :station }

  describe '#initialize' do
    it 'should initialize the class with a balance of zero' do
      expect(card.balance).to eq(0)
    end

    it 'should initialize with an entry station of nil' do
      expect(card.entry_station).to eq(nil)
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

  describe '#deduct' do
    it 'should deduct a specified fare,then return the remaining balance' do
      card.top_up(30)
      expect(card.deduct(10)).to eq(20)
    end
  end

  describe '#touch_in' do
    it 'should accept an argument of the entry station, and store it' do
      card.top_up(50)
      card.touch_in(station)
      expect(card.entry_station).to eq station
    end

    it 'should be in_journey after touching in' do
      card.top_up(50)
      card.touch_in(station)
      expect(card.in_journey?).to be_truthy
    end

    it 'should raise an error if user tries to travel under minimum balance' do
      message = "Insuffient funds, please top up by #{min_balance}"
      expect { card.touch_in(station) }.to raise_error JourneyError, message
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

    it 'should deduct a correct amount from my card when journey is complete' do
      expect { card.deduct }.to change { card.balance }.by(-min_fare)
    end

    it 'should accept an argument of the exit station, and store it' do
      expect(card.exit_station).to eq(station2)
    end
  end
end
