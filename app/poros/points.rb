require 'time'

class Points
  attr_reader :points, :payer, :timestamp

  def initialize(attr)
    @points = attr[:points]
    @payer = attr[:payer]
    @timestamp = attr[:timestamp]
  end

  def self.order(transactions)
    result = transactions.sort_by do |transaction|
      Time.parse(transaction.timestamp)
    end
  end

  def spend(points)
    if points > 0 && @points.negative?
      -@points + points
    elsif points > 0
      -@points
    else
      @points
    end
  end
  #get all the unique names of the payers
  #set those as keys
  # when the keys match the transaction then add to the hash total
end
