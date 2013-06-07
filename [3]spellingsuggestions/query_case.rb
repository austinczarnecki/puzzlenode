class QueryCase
	def initialize(query, word_one, word_two)
		# puts query + " " + word_one + " " + word_two # debugging code!
		@query = query
		@word1 = word_one
		@word2 = word_two
	end

	# returns the word that shares the lcs with the query
	def match
		# returns the length of the two dictionary words
		word_one_lcs_size = largest_common_subsequence(@query, @word1)

		word_two_lcs_size = largest_common_subsequence(@query, @word2)

		# return the word that has a larger lcss with @query
		# note that this defaults to word 2
		# return error message in this case so that the user knows?

		if word_one_lcs_size > word_two_lcs_size
			return @word1
		else
			return @word2
		end
	end

	private
		# finds the largest common subsequence of two words passed as input
		def largest_common_subsequence(string1, string2)
			# converts each string into an array
			array1 = string1.scan(/./)
			array2 = string2.scan(/./)

			# sets the c(olumn) and r(ow) variables which are simply the length of the input strings
			c = array1.size + 1
			r = array2.size + 1

			puts c, r

			# makes an array with r+1 rows and c+1 columns 
			# reference an x, y coordinate in the array by doing
			# subsequence_tracker[y][x]
			subsequence_tracker = Array.new(r) { Array.new(c, 0) }
			
			x = 1
			y = 1
			# iterate for each letter in the first input word
			while y < r
				while x < c
					if array1[x - 1] == array2[y - 1]
						subsequence_tracker[y][x] = subsequence_tracker[y - 1][x - 1] + 1
					else
						subsequence_tracker[y][x] = [subsequence_tracker[y - 1][x], subsequence_tracker[y][x - 1]].max
					end

					x += 1
				end

				y += 1
				x = 0
			end

			puts subsequence_tracker.inspect

			lcs = subsequence_tracker[r - 1][c - 1]

			# puts longest_common_subsequence # debugging code!
			return lcs
		end
end