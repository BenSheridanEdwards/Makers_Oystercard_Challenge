require_relative 'station'

class OysterCard
  LIMIT = 100
  MINIMUM_BALANCE = 1

  attr_reader :balance
  attr_reader :journey_list

  def initialize(journey_class = Journey, balance = 0)
    @balance = balance
    @journey_list = []
    @journey_class = journey_class
  end

  def top_up(amount)
    total = @balance + amount
    raise top_up_amount_error(amount) if total > LIMIT

    @balance += amount
  end

  def touch_in(station)
    deduct @current_journey.fare if in_journey?
    raise minimum_balance_error if @balance < MINIMUM_BALANCE

    start_journey(station)
  end

  def touch_out(station)
    finish_journey(station)
    record_journey
  end

  def in_journey?
    @current_journey
  end

  private

  def record_journey
    @journey_list << @current_journey
    @current_journey = nil
  end

  def start_journey(station)
    @current_journey = @journey_class.new
    @current_journey.start(station)
  end

  def finish_journey(station)
    @current_journey = @journey_class.new unless in_journey?
    @current_journey.finish(station)
    deduct(@current_journey.fare)
  end

  def top_up_amount_error(amount)
    message = "Can't exceed #{LIMIT} with #{amount}"
    BalanceError.new(message)
  end

  def minimum_balance_error
    message = "Insuffient funds, please top up by #{MINIMUM_BALANCE}"
    JourneyError.new(message)
  end

  def deduct(fare)
    @balance -= fare
  end
end

class BalanceError < StandardError
end

class JourneyError < StandardError
end
