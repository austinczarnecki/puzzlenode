# save input lines to an array
# create method to follow path through 2D array (pass in array if exists, follow if next step specified in array, otherwise explore)

class Solution
  def main
    read_input_file
    @branch_history = []
    @ar_count = 0
    while !test_thread
      @ar_count = 0
    end
    puts "Done!"
  end

  def test_thread
    count = 0
    @discard_pile = []
    #get initial hands
    shady = ["Shady"]
    get_hand(shady)
    rocky = ["Rocky"]
    get_hand(rocky)
    danny = ["Danny"]
    get_hand(danny)
    lil = ["Lil"]
    get_hand(lil)
    #puts shady.inspect, rocky.inspect, danny.inspect, lil.inspect

    #set up output file
    output = File.open('output.txt', 'w') do |f2|
      f2.puts lil[1..-1].join(" ").to_s
      count+=1
      while @ar[@ar_count] #while there are more input lines
        # gets moves and updates the hand of the appropriate player
        @pending_moves = []
        @pending_moves << update_hand(shady)
        @pending_moves << update_hand(rocky)
        @pending_moves << update_hand(danny)

        moves = get_line
        signal_set = []
        3.times do
          signal_set << get_line
        end
        if !@branch_history[count - 1]
          # if branch is unexplored, test all signals
          i = 0
          branch_results = Array.new(3)
          while i < 3
            #puts "The real signals are: " + signal_set[i].inspect
            moves_temp = []
            lil_copy = []
            signal_temp = []
            for item in moves
              moves_temp << item
            end
            for item in lil
              lil_copy << item
            end
            for item in signal_set[i]
              signal_temp << item
            end
            result = check_signals_and_update_lil(lil_copy, moves_temp, signal_temp, shady, rocky, danny)
            #puts "The signal works?" + result.inspect
            branch_results[i] = result
            puts "Branch results are currently: " + branch_results.inspect
            i+= 1
          end
          @branch_history << branch_results
          puts "Branch history array is: " + @branch_history.inspect
        end
        if @branch_history.last == [false, false, false]
          while @branch_history.last == [false, false, false] # no signals are true in the last branch
            # delete the first true on the previous signal, and delete the last branch
            @branch_history[-2][@branch_history[-2].index(true)] = false
            @branch_history[-1] = nil
            @branch_history.compact!

            puts "There was a set of falses"
            puts "The new branch history is: " + @branch_history.inspect
          end
          return false
        else
          # update using the signal index matching the first true
          check_signals_and_update_lil(lil, moves, signal_set[@branch_history[count - 1].index(true)], shady, rocky, danny)
          f2.puts lil[1..-1].join(" ").to_s
          count+=1
        end
      end
    end
    if count == 6
      return true # successfully printed full output
    else
      return false
    end
  rescue TypeError
    puts "There was a type error"
    return false
  end

  def get_hand(ar)
    cards = get_line
    cards.each do |card|
      card = card[/[0-9a-zA-Z?]+/]
      ar << card
    end
  end

  def update_hand(ar)
    moves = get_line
    pending_moves = []
    moves.each do |mv|
      #parse the move
      gain = true if mv[/\+/]
      card = mv[/[a-zA-Z0-9?]+/]
      action = mv[/[a-zA-Z0-9?]+\z/]

      # set booleans for moves
      card == action ? draw = true : draw = false
      gain && ( action != card ) ? receive = true : receive = false
      !gain && ( action != "discard" ) ? pass = true : pass = false

      # if the move is a pass, save as a pending move
      if pass
        if action == "Lil"
          pending_moves << [mv, ar]
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

  def validate_pass(ar, action, signal_gain, signal_action, signal_card)
    return false if signal_gain # there is a + instead of a - indicating pass
    return false if action != signal_action # signal and move recipients are different
    return false if @discard_pile.index(signal_card) # card is already discarded
    return false if !ar.index(signal_card) # card is not in hand
    return false if
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
    moves.each do |mv|
      #parse the move
      gain = true if mv[/\+/]
      card = mv[/[a-zA-Z0-9?]+/]
      action = mv[/[a-zA-Z0-9?]+\z/]

      # set booleans for moves
      card == action ? draw = true : draw = false
      gain && ( action != card ) ? receive = true : receive = false
      !gain && ( action != "discard" ) ? pass = true : pass = false

      if signal.size > 0
        signal_gain = true if signal.first[/\+/]
        signal_card = signal.first[/[a-zA-Z0-9?]+/]
        signal_action = signal.first[/[a-zA-Z0-9?]+\z/]
      end

      if pass
        if card == "??"
          if validate_pass(ar, action, signal_gain, signal_action, signal_card)
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

  def get_line
    line = @ar[@ar_count].split(" ")[1..-1]
    @ar_count+=1
    return line
  end

  def read_input_file
    file_name = ARGV.first
    f = open(file_name)
    @ar = []
    f.each do |line|
      @ar << line.chomp
    end
  end
  class SignalError < StandardError
  end
end

s = Solution.new
s.main