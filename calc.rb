class Calc
  def int_char(rank) # turns number rank into char rank
    return 'A' if rank == 14
    return 'K' if rank == 13
    return 'Q' if rank == 12
    return 'J' if rank == 11
    return rank if rank < 11
  end

  def print2(cards, combo) # print cards with combo name
    if cards.kind_of?(Array) 
      print "\n It's " + combo + ': '
      cards.each do |i|
        print '|' + int_char(i.rank).to_s + i.suit + '|'
      end
      print "\n"
    end
  end

  def sort(arr) # sort cards by rank
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
  end

  def search_combo(summary) # container of other searching methods
    sort(summary)

    pair = pair?(summary)
    two_p = two_pairs?(summary)
    set = triple?(summary)
    four = four_of_a_kind?(summary)
    fh = fullhouse?(summary)
    straight = straight?(summary)
    flush = flush?(summary)
    str_flush = straight_flush?(summary)
    royale_fl = royale_flush?(summary)

    print2(pair[1], 'pair') if pair[0] 
    print2(two_p[1], 'two pairs') if two_p[0] 
    print2(set[1], 'set') if set[0] 
    print2(four[1], 'four of a kind') if four[0] 
    print2(fh, 'fullhouse') if fh
    print2(straight[1], 'straight') if straight[0] 
    print2(flush[1], 'flush') if flush[0] 
    print2(str_flush[1], 'straight flush') if str_flush[0] 
    print2(royale_fl[1], 'royale flush') if royale_fl[0] 
  end

  def straight?(cards) 
    sort(cards)
    counter = 0
    res = []
    cards.each do |i|
      if cards.index(i) < cards.length - 1 # if index of card in array isn't last 
        if i.rank - cards[cards.index(i) + 1].rank == -1 # check difference between this and next card
          counter += 1 # if difference in ranks = -1
          res.push(i) # add this card into array
          if cards.index(i) == cards.length - 2 # if the card's penultimate 
            res.push(cards[cards.index(i) + 1]) # then add the last card as well
          end
        end
      end
    end

    if counter > 4 # if we have streak of cards >4
      if res.length > 5 # if the streak is greater then 5
        res.each do |j|
          res.each do |i|
            if res.index(i) < res.length - 5 # leave only the last five cards (because they have higher rank)
              res.delete(i) # remove fewer ranks from array
            end
          end
        end
      end
      return [true, res] # return array of true and array of cards
    end

    [false, 0] # if it's not straight 
  end

  def pair?(cards)
    sort(cards)
    state = false
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length - 1
        if i.rank == cards[cards.index(i) + 1].rank 
          state = true
          result.push(i, cards[cards.index(i) + 1]) # push this card and the next card (if heir ranks are the same)
          res = [state, result]
          return res
        end
      else
        result.push(0)
      end
    end
    res = [false,0]
    res
  end

  def two_pairs?(cards)
    one_pair = pair?(cards) # check does it have one pair
    if one_pair[0]
      state = false
      result = []
      cards.each do |i|
        if cards.index(i) < cards.length - 1
          if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank != one_pair[1][0].rank) # repeat the same as in 'pair?' but the ranks must differ
            state = true
            result.push(i, cards[cards.index(i) + 1])
            res = [state, one_pair[1] + result]
            return res
          end
        else
          result.push(0)
        end
      end
      res = [false, 0]
      return res
    end
    res = [false, 0]
    res
  end

  def triple?(cards)
    state = false
    sort(cards)
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length - 2
        if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank == cards[cards.index(i) + 2].rank) # if three cards in a row are the same
          state = true
          result.push(i,cards[cards.index(i) + 1],cards[cards.index(i) + 2]) # push into array this three cards
          res = [state, result] 
          return res
        end
      else
        result.push(0)
      end
    end
    res = [false, 0]
    res
  end

  def four_of_a_kind?(cards) # the same as 'triple?' but 'if' is longer :D
    state = false
    result = []
    cards.each do |i|
      if cards.index(i) < cards.length - 2
        if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank == cards[cards.index(i) + 2].rank) && (i.rank == cards[cards.index(i) + 3].rank)
          state = true
          result.push(i, cards[cards.index(i) + 1], cards[cards.index(i) + 2], cards[cards.index(i) + 3]) 
          res = [state, result]
          return res
        end
      else
        result.push(0)
      end
    end
    res = [false, 0]
    res
  end

  def fullhouse?(cards)
    trip = triple?(cards) # check do cards have set
    if trip[0] 
      cards.each do |i|
        if cards.index(i) < cards.length-1
          if (i.rank == cards[cards.index(i) + 1].rank) && (i.rank != trip[1]) # if they have set of 3 cards, then search for pair with different rank
            return true
          end
        end
      end
    else
      false
    end
  end


  def flush?(cards)
    s = 0
    c = 0
    h = 0
    d = 0
    cards.each do |i|
      case i.suit # check the suit of card and increment variable 
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
    if s >= 5 # if we have five or greater cards with the same suit
      result = find_suit(cards, '♠') # see description of 'find_suit' below
      return [true, result]
    end
    if c >= 5
      result = find_suit(cards, '♣')
      return [true, result]
    end
    if d >= 5
      result = find_suit(cards, '♦')
      return [true, result]
    end
    if h >= 5
      result = find_suit(cards, '♥')
      return [true, result]
    end
    final = [false, 0]
    final
  end

  def find_suit(cards, suit1) # find all cards with the same suit and return an array of them
    result = []
    cards.each do |i|
      result.push(i) if i.suit == suit1
    end
    sort(result)
    result
  end

  def straight_flush?(cards)
    is_flush = flush?(cards) 
    if is_flush[0] # if it's flush
      str8 = straight?(is_flush[1]) 
      return str8 if str8[0] # and if it's straight then it's straight flush :)
    else
      return [false, 0]
    end
    [false, 0]
  end

  def royale_flush?(cards)
    str8_fl = straight_flush?(cards) # check if it's str8 flush
    if str8_fl[0] 
      if (str8_fl[1][0].rank == 10) && (str8_fl[1][4].rank == 14) # if cards are between '10' and 'A'
        return str8_fl
      else
        return [false, ['ERR1']]
      end
    else
      return [false, ['ERR']]
    end
  end
end
