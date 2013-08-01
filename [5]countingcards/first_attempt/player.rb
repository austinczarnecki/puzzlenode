class Player
	attr_accessor :name, :hand

	def initialize(name, hand)
		@name = name
		@hand = Hand.new(hand)
	end

	def move(moves)
		# pass in an array of moves, perform each one according to what it says
		moves.shift()
		while moves.size != 0
			action = moves.shift()
			#puts action.inspect
			# parse action
			if action[0] == "+"
				gain = true
			else
				gain = false
			end

			if action[1,2] == "10"
				card = action[1,3]

				if action[4] == ":" && action[5] != "d"
					player = action[5]
				else 
					player = nil
				end
			else
				card = action[1,2]

				if action[3] == ":" && action[4] != "d"
					player = action[4]
				else
					player = nil
				end
			end

			# perform action on hand object

			if player == nil
				if gain
					@hand.draw(card)
				else
					@hand.discard(card)
				end
			else
				if gain
					@hand.receive(card, player)
				else
					@hand.pass(card, player) 
				end
			end
		end
	end
end