require './game'

file_name = ARGV.first

@file = open(file_name)
@discard_pile = []

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
  puts "The player (and hand) is: " + ar.inspect
  pending_moves = []
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

    if gain
      puts "gain is true"
    end
    # puts "the card is: " + card
    # puts "the action is: " + action
    # puts "The player draws the card" if draw == true
    # puts "The player discards the card" if action == "discard"
    # puts "The player passes to #{action}" if pass
    # puts "The player receives from #{action}" if receive

    # if the move is a pass, save as a pending move
    if pass
      if action == "Lil"
        pending_moves << mv
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
    puts "The player and new hand is: " + ar.inspect
  end
  pending_moves
end

def get_signals
  signals = @file.gets.split(" ")[1..-1]
end

def check_signals_and_update_lil(ar, shady, rocky, danny)
  moves = @file.gets.split(" ")[1..-1]
  puts "The player (and hand) is: " + ar.inspect
  pending_moves = []
  signal = get_signals
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

    if gain
      puts "gain is true"
    end
    puts "the card is: " + card
    puts "the action is: " + action
    puts "The player draws the card" if draw == true
    puts "The player discards the card" if action == "discard"
    puts "The player passes to #{action}" if pass
    puts "The player receives from #{action}" if receive

    if signal.size > 0
      signal_gain = true if signal.first[/\+/]
      signal_card = signal.first[/[a-zA-Z0-9?]+/]
      signal_action = signal.first[/[a-zA-Z0-9?]+\z/]
    end

    if pass
      # check a bunch of stuff, create another method for this
      if card == "??"
        if !signal_gain && action == signal_action && !@discard_pile.index(signal_card)
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
        if signal_gain && (signal_action == action)
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
        if signal_card == signal_action
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
  return "true"
rescue SignalError
  return "false"
end

# initialize player hands
Shady = ["Shady"]
get_hand(Shady)
Rocky = ["Rocky"]
get_hand(Rocky)
Danny = ["Danny"]
get_hand(Danny)
Lil = ["Lil"]
get_hand(Lil)
puts Shady.inspect, Rocky.inspect, Danny.inspect, Lil.inspect

output = File.open('output.txt', 'w') do |f2|
  f2.puts Lil[1..-1].join(" ").to_s
  while @file
    # gets moves and updates the hand of the appropriate player
    @pending_moves = []
    @pending_moves << update_hand(Shady)
    @pending_moves << update_hand(Rocky)
    @pending_moves << update_hand(Danny)
    puts "Pending moves are: " + @pending_moves.inspect
    puts "Signal works: " + check_signals_and_update_lil(Lil, Shady, Rocky, Danny)
    f2.puts Lil[1..-1].join(" ").to_s
  end
end

