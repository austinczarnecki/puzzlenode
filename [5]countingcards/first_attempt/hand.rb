require './discard_pile'

class Hand
	@@discard_pile = Object::DiscardPile.new()

	def Hand.discard_pile
		@@discard_pile.show
	end

	def initialize(cards)
		@cards = cards
	end

	def draw(card)
		@cards << card
		@cards.sort!
	end

	def discard(card)
		# check if card is explicitly known to be in hand
		i = @cards.index(card)
		# if yes, then remove it
		if i
			@cards[i] = nil
			@cards.compact!
		# if not, then remove one of the ?? cards
		else
			j = @cards.index("??")
			@cards[j] = nil
			@cards.compact!
		end

		@@discard_pile.add(card)
	end

	def pass(card, player)
		# similar to discard
		i = @cards.index(card)
		if i
			@cards[i] = nil
			@cards.compact!
		else
			j = @cards.index("??")
			@cards[j] = nil
			@cards.compact!
		end
	end

	def receive(card, player)
		@cards << card
		@cards.sort!
	end

	def print
		puts @cards
	end
end