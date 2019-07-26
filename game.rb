require_relative 'card'
require_relative 'calc'

class Game
  def initialize
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    @suits = ['♠', '♥', '♦', '♣']
    @usercards = []
    @tablecards = []
  end

  def int_ch(rank) # turns number rank into char rank
    return 'A' if rank == 14
    return 'K' if rank == 13
    return 'Q' if rank == 12
    return 'J' if rank == 11
    return rank if rank < 11
  end

  def pass_hand
    fc = Card.new(@ranks, @suits) # create random card
    @usercards.push(fc) # push it to user's cards array
    sc = fc
    sc = Card.new(@ranks, @suits) while sc == fc # check if the 2nd card is the same as the 1st
    @usercards.push(sc) # if it's not the same, push it into user's array
  end

  def pass_table

    for i in 1..5 do
      break if @tablecards.length == 5
      card = Card.new(@ranks, @suits)
      if !exists(card) # to be shure that all cards are different
        @tablecards.push(card) 
      else
        pass_table
      end
    end
  end

  def exists(card)
    @tablecards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit # check the card in user's cards
    end
    @usercards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit # check the card among cards on table
    end
    false
  end

  def print1 # print cards
    @usercards.each do |i|
      print '|' + int_ch(i.rank).to_s + i.suit + '|'
    end
    print "\n"
    @tablecards.each do |i|
      print '|' + int_ch(i.rank).to_s + i.suit + '|'
    end
  end

  def play
    pass_hand
    pass_table
    print1
    proc = Calc.new
    summary = @usercards + @tablecards
    proc.search_combo(summary)
  end
end

g = Game.new
g.play
