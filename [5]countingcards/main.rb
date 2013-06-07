require './hand'
require './round'
require './game'
require './player'
require './discard_pile'

file_name = ARGV.first

cool = Game.new(file_name)

while cool.another_round_exists?
	cool.play_round
end