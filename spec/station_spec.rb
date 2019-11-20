require "station"

describe Station do

  describe '#initialize' do 

    it "should create a class instance of the station name" do 
      station = Station.new("London Liverpool Street", 1)
      expect(station.name).to eq "London Liverpool Street"
    end

    it "should create a class instance of the station zone" do
      station = Station.new("London Liverpool Street", 1)
      expect(station.zone).to eq 1
    end
  end
end
