class Round
	def initialize(players, discards, file, file_reader)
		@players = players
		@discarded_cards = discards
		@file = file
		@f = file_reader

		get_player_moves
		get_signals
	end

	def result
		# returns lil's possible hands at the end of the round
	end

	private
		def get_player_moves
			while @f.peek[0, 1] != "*"
				line = @f.next
				puts line.inspect
			end
		end

		def get_signals
			while @f.peek[0, 1] == "*"
				line = @f.next
				puts line.inspect
			end
		end
end