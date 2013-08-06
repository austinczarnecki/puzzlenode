
file_name = ARGV.first

@file = open(file_name)
@discard_pile = []
@branch_points = []

class SignalError < StandardError
end

# utility methods
def get_hand(ar)
  line = @file.gets
  cards = line.split(" ")[1..4]
  cards.each do |card|
    card = card[/[0-9a-zA-Z?]+/]
    ar << card
  end
end

def update_hand(ar)
  moves = @file.gets.split(" ")[1..-1]
  # puts "The player (and hand) is: " + ar.inspect
  pending_moves = []
  moves.each do |mv|
    #puts mv
    #parse the move
    gain = true if mv[/\+/]
    card = mv[/[a-zA-Z0-9?]+/]
    action = mv[/[a-zA-Z0-9?]+\z/]

    # set booleans for moves
    card == action ? draw = true : draw = false
    gain && ( action != card ) ? receive = true : receive = false
    !gain && ( action != "discard" ) ? pass = true : pass = false

    # puts "the card is: " + card
    # puts "the action is: " + action
    # puts "The player draws the card" if draw == true
    # puts "The player discards the card" if action == "discard"
    # puts "The player passes to #{action}" if pass
    # puts "The player receives from #{action}" if receive

    # if the move is a pass, save as a pending move
    if pass
      if action == "Lil"
        pending_moves << [mv, ar.first]
      end
      if ar.index(card)
        ar[ar.index(card)] = nil
      else
        ar[ar.index("??")] = nil
      end
      ar.compact!
    elsif action == "discard"
      #add the card to the discard pile, then either delete it from the hand or delete a question-mark
      @discard_pile << card
      if ar.index(card)
        ar[ar.index(card)] = nil
      else
        ar[ar.index("??")] = nil
      end
      ar.compact!
    elsif receive
      ar << card
      # if the move is a receive, look for a matching pending move and resolve (there should not be conflicts here)
    elsif draw
      ar << card
    end
    # puts "The player and new hand is: " + ar.inspect
  end
  pending_moves
end

def get_signals
  signals = @file.gets.split(" ")[1..-1]
end

def validate_pass(ar, action, signal_gain, signal_action, signal_card)
  return false if signal_gain # there is a + instead of a - indicating pass
  return false if action != signal_action # signal and move recipients are different
  return false if @discard_pile.index(signal_card) # card is already discarded
  return false if !ar.index(signal_card) # card is not in hand
  return true
end
def validate_receive(ar, action, signal_gain, signal_action, signal_card)
  return false unless signal_gain
  return false unless signal_action == action
  return false if ar.index(signal_card)
  return false if @discard_pile.index(signal_card)
  # check pending moves and return false if there is not a pending pass to lil from someone with the
  # specified card in their hand at the time the pass was made.
  return true
end
def validate_draw(ar, signal_gain, signal_action, signal_card)
  return false if ar.index(signal_card)
  return false if @discard_pile.index(signal_card)
  return false unless signal_card == signal_action
  return false unless signal_gain
  return true
end

def check_signals_and_update_lil(ar, moves, signal, shady, rocky, danny)
  puts "The player (and hand) is: " + ar.inspect
  puts "The signals are: " + signal.inspect
  puts "The moves are: " + moves.inspect

  moves.each do |mv|
    puts mv
    #parse the move
    gain = true if mv[/\+/]
    card = mv[/[a-zA-Z0-9?]+/]
    action = mv[/[a-zA-Z0-9?]+\z/]

    # set booleans for moves
    card == action ? draw = true : draw = false
    gain && ( action != card ) ? receive = true : receive = false
    !gain && ( action != "discard" ) ? pass = true : pass = false

    # puts "the card is: " + card
    # puts "the action is: " + action
    # puts "The player draws the card" if draw == true
    # puts "The player discards the card" if action == "discard"
    # puts "The player passes to #{action}" if pass
    # puts "The player receives from #{action}" if receive

    if signal.size > 0
      signal_gain = true if signal.first[/\+/]
      signal_card = signal.first[/[a-zA-Z0-9?]+/]
      signal_action = signal.first[/[a-zA-Z0-9?]+\z/]
    end

    if pass
      # check a bunch of stuff, create another method for this
      if card == "??"
        if validate_pass(ar, action, signal_gain, signal_action, signal_card)
          puts ar.index(signal_card)
          ar[ar.index(signal_card)] = nil
          ar.compact!
          signal.shift
        else
          raise SignalError
        end
      else
        ar[ar.index(card)] = nil
        ar.compact!
      end
    elsif action == "discard"
      # should always know Lil's complete hand so this should always work
      ar[ar.index(card)] = nil
      ar.compact!
    elsif receive
      if card == "??"
        if validate_receive(ar, action, signal_gain, signal_action, signal_card)
          ar << signal_card
          signal.shift
        else
          raise SignalError
        end
      else
        ar << card
      end
    elsif draw
      if card == "??"
        # check if the pending move for lil is a draw. If yes, then add the draw value from the signal
        # otherwise, raise signal error
        if validate_draw(ar, signal_gain, signal_action, signal_card)
          ar << signal_card
          signal.shift
        else
          raise SignalError
        end
      else
        ar << card
      end
    end
  end
  return true
rescue SignalError, TypeError
  return false
end

Shady = ["Shady"]
get_hand(Shady)
Rocky = ["Rocky"]
get_hand(Rocky)
Danny = ["Danny"]
get_hand(Danny)
Lil = ["Lil"]
get_hand(Lil)
puts Shady.inspect, Rocky.inspect, Danny.inspect, Lil.inspect

# follows one path until reaching a false result.
# returns false if path does not reach end of file, returns true if it does.
def test(ar)
  # initialize player hands


  output = File.open('output.txt', 'w') do |f2|
    f2.puts Lil[1..-1].join(" ").to_s
    branch_level = 0
    while @file
      # gets moves and updates the hand of the appropriate player
      @pending_moves = []
      @pending_moves << update_hand(Shady)
      @pending_moves << update_hand(Rocky)
      @pending_moves << update_hand(Danny)
      #puts "Pending moves are: " + @pending_moves.inspect
      moves = @file.gets.split(" ")[1..-1]
      #puts "The real moves are: " + moves.inspect
      branch_results = [nil, nil, nil]
      signal_set = []
      3.times do
        signal_set << get_signals
      end
      i = 0
      while i < 3
        puts "The real signals are: " + signal_set[i].inspect
        moves_temp = []
        lil_copy = []
        signal_temp = []
        for item in moves
          moves_temp << item
        end
        for item in Lil
          lil_copy << item
        end
        for item in signal_set[i]
          signal_temp << item
        end
        result = check_signals_and_update_lil(lil_copy, moves_temp, signal_temp, Shady, Rocky, Danny)
        puts "The signal works?" + result.inspect
        branch_results[i] = result
        i+= 1
      end
      # this is an array of arrays, where each sub-array has 3 values indicating which signals work at this level of branching
      @branch_points << branch_results

      # need to check the first true and move forward. If all are failures, move back a step and try the next true in the last array containing true values
      if @branch_points[branch_level].index(true)
        check_signals_and_update_lil(Lil, moves, signal_set[@branch_points[branch_level].index(true)], Shady, Rocky, Danny)
        # else go back to the previous level
      else
        @branch_points[branch_level-1][@branch_points[branch_level-1].index(true)] = false
      end

      puts "Branch points array: " + @branch_points.inspect
      f2.puts Lil[1..-1].join(" ").to_s
      branch_level+= 1
    end
  end
end

def array_builder(n)
  if n == 0
    ar = []
    ar << [true]
    ar << [false]
    puts ar.inspect
    return ar
  else
    ar = []
    old_ar = array_builder(n-1)
    for item in old_ar

      new_item = Array.new(item.size)
      for object in new_item
        new_item[new_item.index(object)] = item[new_item.index(object)]
      end
      new_item << true
      ar << new_item

      new_item = Array.new(item.size)
      for object in new_item
        new_item[new_item.index(object)] = item[new_item.index(object)]
      end
      new_item << false
      ar << new_item

    end
    puts ar.inspect
    return ar
  end
end

array_builder(2)











