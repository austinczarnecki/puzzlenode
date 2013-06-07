class Game
	def initialize(file_name)
		# opens the file
		@file = open(file_name)

		# make a player object for each player in the game (there are always 4)
		@player1 = make_player
		@player2 = make_player
		@player3 = make_player
		@player4 = make_player

		puts @player1.inspect
		puts @player2.inspect
		puts @player3.inspect
		puts @player4.inspect

		@players = [@player1, @player2, @player3, @player4]

		@discarded_cards = DiscardPile.new

		@f = @file.each
	end

	def play_round
		Round.new(@players, @discarded_cards, @file, @f)
	end

	def another_round_exists?
		if @f.peek
			true
		else
			false
		end
	end

	def results
		# prints lil's hand each turn throughout the game
		output = open('output.txt', 'w') do |f2|

			while @file.gets
				round = Round.new(@players, @discarded_cards)
				f2.puts round.result
			end
		end
	ensure
		output.close if output
	end

	private
	  	def make_player
	  		line = @file.gets
			words = line.split
			cards = []

			name = words.first
			4.times do |item|
				cards = words[1..4]
			end

			return Player.new(name, cards)
	  	end
end