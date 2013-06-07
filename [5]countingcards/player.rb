class Player
	attr_accessor :name, :hand

	def initialize(name, hand)
		@name = name
		@hand = Hand.new(hand)
	end

	def move(moves)
		# pass in an array of moves, perform each one according to what it says
		for element in moves

		end
	end
end