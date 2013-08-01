class DiscardPile
	def initialize
		@discards = Array.new
	end

	def show
		puts @discards.inspect
	end

	def add(card)
		@discards << card
		@discards.sort!
	end

	def contains?(card)
		@discards.include?
	end
end