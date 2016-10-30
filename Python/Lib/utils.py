names_list = []
def heading (title):
    print ("")
    print (title)
    print ("="*len(title))

def pr_list_as_line (pr_list):
    print ('  '.join (pr_list))

def col_headers (col_names):
    global names_list 
    del names_list[:]
    for c in col_names:
        fmt = '>' + str(c[1])
        if c[1] < 0:
            fmt = '<' + str(-c[1])
        names_list.append (('{0:'+fmt+'}').format(c[0]))
    pr_list_as_line (names_list)
    del names_list[:]
    for c in col_names:
        names_list.append ("-"*abs(c[1]))
    pr_list_as_line (names_list)
   
def tot_lines ():
    pr_list_as_line (names_list)

