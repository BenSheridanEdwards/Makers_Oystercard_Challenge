require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class OysterCard
  LIMIT = 100
  MINIMUM_BALANCE = 1

  attr_reader :balance

  def initialize(journey_log = JourneyLog.new, balance = 0)
    @balance = balance
    @journey_log = journey_log
  end

  def top_up(amount)
    total = @balance + amount
    raise top_up_amount_error(amount) if total > LIMIT

    @balance += amount
  end

  def touch_in(station)
    deduct @journey_log.journeys.last.fare if @journey_log.in_journey?
    raise minimum_balance_error if @balance < MINIMUM_BALANCE
    @journey_log.start(station)
  end

  def touch_out(station)
    @journey_log.finish(station)
    deduct(@journey_log.journeys.last.fare)
  end

  def journey_history
    @journey_log.journeys
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

  def deduct(fare)
    @balance -= fare
  end
end

class BalanceError < StandardError
end

class JourneyError < StandardError
end
