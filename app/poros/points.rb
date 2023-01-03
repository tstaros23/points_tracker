class Points
  attr_reader :points, :payer, :timestamp

  def initialize(attr)
    @points = attr[:points]
    @payer = attr[:payer]
    @timestamp = attr[:timestamp]
  end
end
