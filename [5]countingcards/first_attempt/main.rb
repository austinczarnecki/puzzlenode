require './hand'
require './round'
require './game'
require './player'
require './discard_pile'

file_name = ARGV.first

cool = Game.new(file_name)

while true
	break if cool.another_round_exists? == false
	cool.play_round
end