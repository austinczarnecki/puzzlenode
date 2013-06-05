class QueryCase
	def initialize(query, word_one, word_two)
		# puts query + " " + word_one + " " + word_two # debugging code!
		@query = query
		@word1 = word_one
		@word2 = word_two
	end

	def match
		# returns the correct of the two dictionary words
		word_one_lcss_size1 = largest_common_substring(@query, @word1)
		word_one_lcss_size2 = largest_common_substring(@word1, @query)

		word_one_lcss_size = [word_one_lcss_size1, word_one_lcss_size2].max

		word_two_lcss_size1 = largest_common_substring(@query, @word2)
		word_two_lcss_size2 = largest_common_substring(@word2, @query)

		word_two_lcss_size = [word_two_lcss_size1, word_two_lcss_size2].max

		# return the word that has a larger lcss with @query
		if word_one_lcss_size > word_two_lcss_size
			return @word1
		else
			return @word2
		end
	end

	private
		# finds the largest common substring of two words passed as input
		def largest_common_substring(string1, string2)
			# converts each string into an array
			array1 = string1.scan(/./)
			array2 = string2.scan(/./)

			# initialize a variable tracking the longest substring found so far
			longest_common_substring = 0

			# while loop iterator
			i = 0

			# iterate for each letter in the first input word
			while i < string1.size
				# initialize the local variable tracking a single substring comparison
				common_substring_length = 0
				offset = 0

				array1.each do |letter|
					# record the index in string 2 where a character matches
					next_matching_index = array2[offset..-1].index(letter)

					# if a match was detected, record an increase in length of common substring
					# also set the new offset for searching the next letters
					if next_matching_index
						# the next line is debugging code:
						# puts next_matching_index.to_s + "  " + letter

						# Update the substring length if a match is found
						# Set a new offset in order to prevent the same character from
						# being picked up more than once.
						common_substring_length += 1
						offset = offset + next_matching_index + 1
					end
				end

				if common_substring_length > longest_common_substring
					longest_common_substring = common_substring_length
				end

				# take off the first letter and shift the array over
				array1.shift
				i += 1
			end

			# puts longest_common_substring # debugging code!
			return longest_common_substring
		end
end