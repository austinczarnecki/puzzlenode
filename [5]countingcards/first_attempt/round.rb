class Round
	def initialize(players, file, file_reader)
		@players = players
		@file = file
		@f = file_reader

		@shady_moves = get_player_moves
		@rocky_moves = get_player_moves
		@danny_moves = get_player_moves
		@lil_moves = get_player_moves

		get_signals

		@players.first.move(@shady_moves)
		@players[1].move(@rocky_moves)
		@players[2].move(@danny_moves)
		@players[3].move(@lil_moves)

		for element in @players
			puts element.inspect
		end

		Hand.discard_pile
		puts Hand.discard_pile.includes?("10C")
	end

	def result
		# returns lil's possible hands at the end of the round
	end

	private
		def get_player_moves
			while @f.peek[0, 1] != "*"
				line = @f.next
				ar = line.split(" ")
				#puts ar.inspect
				return ar
			end
		end

		def get_signals
			while @f.peek[0, 1] == "*"
				line = @f.next
				#puts line.inspect
			end
		rescue StopIteration

		end
end