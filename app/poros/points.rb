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
    if @points.negative?
      -(@points)
    else
      -(points)
    end
  end

  def total_spent(points, transactions)
    hash = Hash.new(0)
    transactions = Points.order(transactions)
    transactions.map do |transaction|
      if transaction.points > points
        hash[transaction.payer] -= points
        break
      else
        hash[transaction.payer] += transaction.spend(transaction.points)
        points -= transaction.points
      end
    end
    hash
  end
end
