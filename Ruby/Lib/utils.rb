module Utils

  $names_list = []
  def Utils.heading(title)
    puts("")
    puts(title)
    puts("="*title.length)
  end

  def Utils.pr_list_as_line(pr_list)
    print(pr_list.join('  '), "\n")
  end

  def Utils.col_headers(col_names)

    $names_list.clear
    col_names.each {|c|
      $names_list.push(sprintf("%#{c[1]}s", c[0]))
    }
    pr_list_as_line($names_list)
    $names_list.clear
    col_names.each {|c|
      $names_list.push("-"*(c[1]).abs)
    }
    pr_list_as_line($names_list)
  end

  def Utils.tot_lines
    pr_list_as_line($names_list)
  end

  def Utils.max_len(stringlist)
    stringlist.max_by(&:length).length
  end

end

