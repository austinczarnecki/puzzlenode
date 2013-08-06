require './spelling_suggestions'
require './query_case'

file_name = ARGV.first

spelling = SpellingSuggestions.new(file_name)

spelling.spelling_suggestions