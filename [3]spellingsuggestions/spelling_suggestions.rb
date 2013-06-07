class SpellingSuggestions
	# require './query_case'

	def initialize(file_name)
		@input = file_name
		puts "Your output will be printed to output.txt in the current directory."
	end

	def spelling_suggestions

		@file = open(@input)
		cases = @file.gets

		output = File.open('output.txt', 'w') do |f2|

			while @file.gets
				#parse the next three words that make up a case
				query = @file.gets.chomp
				word_one = @file.gets.chomp
				word_two = @file.gets.chomp

				# create a new case using the parsed input

				individual_case = QueryCase.new(query, word_one, word_two)

				# print the returned value of the dictionary word with the lcss
				f2.puts individual_case.match
			end
		end
	ensure 
		@file.close if @file
	end
end
