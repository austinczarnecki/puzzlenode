class Solution
  def parse_input(file_name)
    #f = open(file_name)
    @tiles = [
    "a2",
    "a2",
    "a2",
    "i4",
    "w5",
    "n1",
    "r12",
    "e1",
    "g6",
    "f7",
    "s2",
    "e1",
    "l7",
    "t8",
    "r12",
    "l7",
    "h8",
    "n1",
    "f7",
    "b8",
    "r12",
    "a2",
    "u9",
    "g6",
    "i4",
    "t8",
    "l7",
    "q9",
    "o3",
    "d2",
    "s2",
    "f7",
    "n1",
    "u9"
  ]
    dictionary_temp = [
     "amalar",
     "noema",
     "clemiso",
     "hidromuria",
     "ambonio",
     "sustalo",
     "incopelusa",
     "novalo",
     "arnilla",
     "espejunar",
     "apeltronar",
     "reduplimir",
     "trimalciato",
     "ergomanina",
     "filulas",
     "cariaconcia",
     "tordulaba",
     "hurgalios",
     "orfelunios",
     "entreplumaban",
     "ulucordio",
     "encrestoriaba",
     "extrayuxtaba",
     "clinon"
  ]
    @dictionary = check_dictionary(dictionary_temp)
    board_temp = [
      "1 1 1 1 2 1 1 1 3 1 1 1",
      "1 1 1 1 4 1 1 1 1 2 1 2",
      "1 1 1 1 1 1 1 1 1 1 1 1",
      "1 2 1 2 1 1 1 1 1 1 1 1",
      "1 1 1 1 1 1 1 1 1 3 1 3",
      "1 1 1 1 1 1 1 1 1 1 1 1",
      "1 3 1 1 1 1 1 2 2 2 1 1",
      "1 1 1 2 1 2 1 1 1 1 1 2",
      "1 1 1 1 1 1 1 1 1 1 1 1"
  ]
    @board = convert_board(board_temp)
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
      letters << item[/[a-z]/] # keep just letter without value
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
    puts "new dict is : " + new_dict.inspect
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
      v = @tiles[i][/[0-9]/]
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
    return high_score_info.unshift(word) # check this method in irb
  end

  def find_best_word
    highest_score_ar = []
    puts "@dictionary is: " + @dictionary.inspect
    for word in @dictionary
      puts "The current word is: " + word.inspect
      highest_score_ar << test_word(word)
    end
    puts "highest_score_ar is : " + highest_score_ar.inspect
    # find highest score in array of top scores
    highest_score_info = [nil, 0, nil, nil]
    for item in highest_score_ar
      if item[1] > highest_score_info[1]
        highest_score_info = item
      end
    end
    puts "highest_score_info is: " + highest_score_info.inspect
    return highest_score_info
  end

  def print_high_score(ar) # mustpass in highest score info from find_best_word
    i = 0
    x = ar[2][0]
    y = ar[2][1]
    word = ar[0].split("")
    while i < word.size
      @board[y][x] = word[i]
      if ar[3] == "v"
        y+=1
      else
        x+=1
      end
      i+=1
    end
    print_board = []
    for item in @board
      print_board << item.join(" ") # test in irb
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
      score+=(@board[y][x] * wav[i])
      if direction == "v"
        y+=1
      else
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