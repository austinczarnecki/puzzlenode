class DiscardPile
	def initialize()
		@discards = Array.new
	end

	def show
		@discards
	end

	def add(card)
		@discards << card
	end
end