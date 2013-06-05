require './spelling_suggestions'
require './query_case'

file_name = ARGV.first

test = SpellingSuggestions.new(file_name)

test.spelling_suggestions