class OysterCard
  LIMIT = 100
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 5

  attr_reader :balance
  attr_reader :entry_station
  attr_reader :exit_station
  attr_reader :journey_list

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
    @journey_list = []
  end

  def top_up(amount)
    total = @balance + amount
    raise top_up_amount_error(amount) if total > LIMIT

    @balance += amount
  end

  def deduct(fare = MINIMUM_FARE)
    @balance -= fare
  end

  def touch_in(station)
    @entry_station = station
    raise minimum_balance_error if @balance < MINIMUM_BALANCE
  end

  def touch_out(station)
    @entry_station = nil
    @exit_station = station
  end

  def in_journey?
    !@entry_station.nil?
  end

  private

  def top_up_amount_error(amount)
    message = "Can't exceed #{LIMIT} with #{amount}"
    BalanceError.new(message)
  end

  def minimum_balance_error
    message = "Insuffient funds, please top up by #{MINIMUM_BALANCE}"
    JourneyError.new(message)
  end
end

class BalanceError < StandardError
end

class JourneyError < StandardError
end
