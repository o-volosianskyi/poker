require_relative 'card'

class Game
  def initialize
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    @suits = ['♠', '♥', '♦', '♣']
    @usercards = []
    @tablecards = []
  end

  def pass_hand
    fc = Card.new(@ranks, @suits) #create random card
    @usercards.push(fc) #push it to user's cards array
    sc = fc
    sc = Card.new(@ranks, @suits) while sc == fc #check if the 2nd card is the same as 1st
    @usercards.push(sc) #if it's not the same, push it into user's array
  end

  def pass_table
    for i in 1..5 do
      card = Card.new(@ranks, @suits)
      @tablecards.push(card) unless exists(card) #to be shure that all cards are different
    end
  end

  def exists(card)
    @tablecards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit #check the card in user's cards
    end
    @usercards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit #check the card among cards on table
    end
    false
  end

  def int_char(rank)
    return 'A' if rank == 14
    return 'K' if rank == 13
    return 'Q' if rank == 12
    return 'J' if rank == 11
    return rank if rank < 11
  end

  def print1
    @usercards.each do |i|
      print '|' + int_char(i.rank).to_s + i.suit + '|'
    end
    print "\n"
    @tablecards.each do |i|
      print '|' + int_char(i.rank).to_s + i.suit + '|'
    end
  end

  def sort(arr)
    j = 0;
    while j < arr.length
      j += 1
      arr.each do |i|
        ind = arr.index(i)
        if ind < arr.length-1
          if arr[ind].rank > arr[ind+1].rank
            arr[ind], arr[ind + 1] = arr[ind + 1], arr[ind]
          end
        end
      end
    end
    print "\n"
    
  end

  def search_combo
    summary = @usercards + @tablecards
    sort(summary)
    puts "\nPair? " + pair?(summary)[0].to_s + "\n"
    puts 'Triple? ' + triple?(summary)[0].to_s + "\n"
    puts 'Four of a kind? ' + four_of_a_kind?(summary)[0].to_s + "\n"
    puts 'Fullhouse? ' + fullhouse?(summary).to_s + "\n"
    puts 'Str8? ' + straight?(summary).to_s + "\n"
    puts 'Flush? ' + flush?(summary)[0].to_s + "\n"
    puts 'Str8 Flush? ' + straight_flush?(summary)[0].to_s + "\n"

  end

  def straight?(cards)
    counter=0
    res=[]
    cards.each do |i|
      if cards.index(i) < cards.length - 1
        if i.rank - cards[cards.index(i) + 1].rank == -1
          counter += 1
          res.push(i)
          if cards.index(i) == cards.length - 2
            puts "TRUE"
            res.push(cards[cards.index(i) + 1])
          end
        end
      end
    end
    return [true, res] if counter >= 4

    [false, 0]
  end

  def pair?(cards)
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length-1
        result.push(true, i.rank) if i.rank == cards[cards.index(i) + 1].rank
        else
          result.push(false, 0)
      end
    end
    result
  end

  def triple?(cards)
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length - 2
        result.push(true, i.rank) if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank == cards[cards.index(i) + 2].rank)
        else
          result.push(false, 0)
      end
    end
    result
  end

  def four_of_a_kind?(cards)
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length - 2
        result.push(true, i.rank) if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank == cards[cards.index(i) + 2].rank) && (i.rank == cards[cards.index(i) + 3].rank)
         else
           result.push(false, 0)
      end
    end
    result
  end

  def fullhouse?(cards)
    trip = triple?(cards)
    if trip[0] == true
      cards.each do |i|
        if cards.index(i) < cards.length-1
          if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank != trip[1])
            return true
          end
        end
      end
    else
      false
    end
  end

  def flush?(cards)
    result = []
    flag=false
    s=0
    c=0
    h=0
    d=0
    cards.each do |i|
      case i.suit
      when '♠'
        s += 1
      when '♣'
        c += 1
      when '♦'
        d += 1
      when '♥'
        h += 1
      end  
    end
    if s >= 5
      result = find_suit(cards, '♠') 
      flag=true
    end
    if c >= 5
      result = find_suit(cards, '♣') -
      flag=true
    end
    if d >= 5
      result = find_suit(cards, '♦') 
      flag=true
    end
    if h >= 5
      result = find_suit(cards, '♥') 
      flag=true
    end
=begin if result.length > 5
      result.each do |j|
        result.each do |i|
          if result.index(i) < result.length - 5
            result.delete(i) 
          end
        end
      end
    end
=end 
    if flag == true
      final = [true, result]
    else
      final=[false,0]
    end
    final
  end

  def find_suit(cards, suit1)
    result = []
    cards.each do |i|
      result.push(i) if i.suit == suit1
    end
    sort(result)
    result
  end

  def straight_flush?(cards)
    is_flush = flush?(cards)
    if is_flush[0] == true
      str8 = straight?(is_flush[1])
      if str8[0] == true
        return str8
      end
    else
      return [false,0]
    end
  end
end

g = Game.new
g.pass_hand
g.pass_table
g.print1
g.search_combo
