class Hand
	def initialize(cards)
		@cards = cards
	end

	def draw(card)
		@cards << card
	end

	def discard(card)
		# remove the passed in card from the @cards array
	end

	def pass(card, player)
	end

	def print
		puts @cards
	end
end