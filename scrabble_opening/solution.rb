require 'rubygems'
require 'json'

class Solution
  def parse_input(file_name)
    file = open(file_name)
    json = file.read
    parsed = JSON.parse(json)

    @tiles = parsed["tiles"]
    @dictionary = check_dictionary(parsed["dictionary"])
    @board = convert_board(parsed["board"])
  end

  def convert_board(ar)
    converted = []
    for item in ar
      converted << item.split
    end
    integers = Array.new(converted.size) { |i| i = Array.new(converted.first.size) }
    j = 0
    while j < converted.size
      i = 0
      while i < converted.first.size
        integers[j][i] = converted[j][i].to_i
        i+=1
      end
      j+=1
    end
    return integers
  end

  def make_letter_array(ar)
    letters = []
    for item in ar
      letters << item[/[a-z]/]
    end
    letters
  end

  # checks if a given dictionary word from the original dictionary can be made using the given tiles
  def check_word(word)
    letters = make_letter_array(@tiles)
    w = word.split("")
    for letter in w
      if letters.index(letter)
        letters[letters.index(letter)] = nil
        letters.compact!
      else
        return false
      end
    end
    return true
  end

  # returns the dictionary of all valid words for given tiles and their inverses
  def check_dictionary(dict)
    dictionary_redux = []
    for word in dict
      result = check_word(word)
      if result
        dictionary_redux << word
      end
    end
    new_dict = add_reversals(dictionary_redux)
    return new_dict
  end

  def add_reversals(ar)
    array = []
    for item in ar
      array << item
      array << item.reverse
    end
    return array
  end

  def convert_to_values(word)
    values = []
    w = word.split("")
    for item in w
      letters = make_letter_array(@tiles)
      i = letters.index(item)
      v = @tiles[i][/[0-9]+/]
      values << v.to_i
    end
    return values
  end

  def test_word(word) # returns [word, highest score, [x, y], "v" or "h"]
    high_score = 0
    high_score_info = nil
    wav = convert_to_values(word)
    score_ar = []
    i = 0
    while i < @board.size
      j = 0
      while j <= (@board.first.size - wav.size)
        score_ar = [check_score(wav, "h", i, j), [j, i], "h"]
        if score_ar.first > high_score
          high_score = score_ar.first
          high_score_info = score_ar
        end
        j+=1
      end
      i+=1
    end

    i = 0
    while i <= (@board.size - wav.size)
      j = 0
      while j < @board.first.size
        score_ar = [check_score(wav, "v", i, j), [j, i], "v"]
        if score_ar.first > high_score
          high_score = score_ar.first
          high_score_info = score_ar
        end
        j+=1
      end
      i+=1
    end
    return high_score_info.unshift(word)
  end

  def find_best_word
    highest_score_ar = []
    for word in @dictionary
      highest_score_ar << test_word(word)
    end
    # find highest score in array of top scores
    highest_score_info = [nil, 0, nil, nil]
    for item in highest_score_ar
      if item[1] > highest_score_info[1]
        highest_score_info = item
      end
    end
    return highest_score_info
  end


  def print_high_score(ar) # must pass in highest score info from find_best_word
    i = 0
    x = ar[2][0]
    y = ar[2][1]
    word = ar[0].split("")
    while i < word.size
      @board[y][x] = word[i]
      if ar[3] == "v"
        y+=1
      elsif ar[3] == "h"
        x+=1
      else
        raise Exception
      end
      i+=1
    end
    print_board = []
    for item in @board
      print_board << item.join(" ")
    end
    open('output.txt', 'w') do |f|
      f.puts print_board
    end
  end

  def check_score(wav, direction, row, column)
    y = row
    x = column
    score = 0
    i = 0
    while i < wav.size
      score += (@board[y][x] * wav[i])
      if direction == "v"
        y+=1
      elsif direction == "h"
        x+=1
      end
      i+=1
    end
    return score
  end

  def main
    file_name = ARGV.first
    parse_input(file_name)
    print_high_score(find_best_word)
  end
end

a = Solution.new
a.main
