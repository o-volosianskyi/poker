class Card
  def initialize(ranks, suits)
    r = Random.new
    fn = r.rand(0..12)
    fs = r.rand(0..3)
    @rank = ranks[fn]
    @suit = suits[fs]
  end

  attr_reader :rank, :suit
  attr_writer :rank, :suit
end
