require_relative 'card'

class Game
  def initialize
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    @suits = ['♠', '♥', '♦', '♣']
    @usercards = []
    @tablecards = []
  end

  def pass_hand
    fc = Card.new(@ranks, @suits)
    @usercards.push(fc)
    sc = fc
    sc = Card.new(@ranks, @suits) while sc == fc
    @usercards.push(sc)
  end

  def pass_table
    for i in 1..5 do
      card = Card.new(@ranks, @suits)
      @tablecards.push(card) unless exists(card)
    end
  end

  def exists(card)
    @tablecards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit
    end
    @usercards.each do |i|
      return true if card.rank == i.rank && card.suit == i.suit
    end
    false
  end

  def int_char(suit)
    return 'A' if suit == 14
    return 'K' if suit == 13
    return 'Q' if suit == 12
    return 'J' if suit == 11
    return suit if suit < 11
  end

  def print1
    @usercards.each do |i|
      print '|' + i.rank.to_s + i.suit + '|'
    end
    print "\n"
    @tablecards.each do |i|
      print '|' + i.rank.to_s + i.suit + '|'
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
    puts 'Flush? ' + flush?(summary)[0].to_s + "\n"
  end

  def straight?(cards)
    counter=0
    cards.each do |i|
      if cards.index(i) < cards.length
        if i.rank - cards[cards.index(i) + 1].rank == -1
          counter += 1
        end
      end
    end
    return true if counter == 5
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
    result = find_suit(cards, '♠') if s >= 5
    result = find_suit(cards, '♣') if c >= 5
    result = find_suit(cards, '♦') if d >= 5
    result = find_suit(cards, '♥') if h >= 5
    if result.length > 5
      result.each do |j|
        result.each do |i|
          if result.index(i) < result.length - 5
            result.delete(i) 
          end
        end
      end
    end
    result
  end

  def find_suit(cards, suit1)
    result = []
    cards.each do |i|
      result.push(i) if i.suit == suit1
    end
    sort(result)
    result
  end
end

g = Game.new
g.pass_hand
g.pass_table
g.print1
g.search_combo
