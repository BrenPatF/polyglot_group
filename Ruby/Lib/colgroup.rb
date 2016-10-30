require "utils"
def _readList(input_file, delim, col)
  counter = Hash.new(0)
  Utils.heading(input_file)
  x = File.open(input_file, "r") { |file|
    file.each {|line|
      val = line.split(delim)[col]
      counter[val] += 1
    }
  }
  return counter
end

class ColGroup

  def pr_list(sort_by, key_values)
	
    Utils.heading ('Sorting by '+sort_by)
    Utils.col_headers([['Team',-@max_len], ['#apps',5]])
    key_values.each {|k,v|
      puts(sprintf("%-"+@max_len.to_s+"s  %5s", k, v.to_s))
	}

  end

  def initialize(input_file, delim, col)
    @counter = _readList(input_file, delim, col)
    @max_len=Utils.max_len(@counter.keys)
  end
  def sort_by_key
    return @counter.sort
  end
  def sort_by_value
    return @counter.sort_by {|k, v| [v, k]}
  end
  def list_as_is
    return @counter.map {|k,v|
      [k,v]
    }
  end
end

