require "journey"

describe Journey do
  let(:station1) { double(:entry_station, zone: 1) }
  let(:station2) { double(:exit_station, zone: 3) }
  let(:zone_fare) { 2 }

  describe "#fare" do
    it "should be zero by default" do
      expect(subject.fare).to eq 0
    end
  end

  context "when starting a journey" do
    before :each do
      subject.start station1
    end

    it "should be in journey" do
      expect(subject.in_journey).to eq true
    end

    it "should return the entry station" do
      expect(subject.entry_station).to eq station1
    end

    it "should charge a penalty fare if there is no exit station" do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end

  context "when finishing a journey" do
    before :each do
      subject.start station1
      subject.finish station2
    end

    it "should complete the journey" do
      expect(subject.in_journey).to eq false
    end

    it "should have an exit station" do
      expect(subject.exit_station).to eq station2
    end

    it "should charge the minimum fare upon completetion of a journey" do
      expect(subject.fare).to eq Journey::MINIMUM_FARE + zone_fare
    end
  end

  context "when finishing a journey that never started" do
    it "should charge a penalty fare" do
      subject.finish station2
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end
end
