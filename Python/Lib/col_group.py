from operator import itemgetter
from utils import *
def _readList(input_file, delim, col):
    counter = {}
    print("Opening file "+input_file)
    with open(input_file) as f:
        for line in f:
            val = line.split (delim)[col]
            counter[val] = counter.get(val, 0) + 1 # +=1 doesn't work
    return counter

class ColGroup:

    def __init__(self, input_file, delim, col):
        self.counter = _readList (input_file, delim, col)
        global max_len
        max_len = len(max(self.counter.keys(), key=len))

    def pr_list(self,sort_by,key_values):
        heading ('Counts sorted by '+sort_by)
        col_headers([['Team',-max_len], ['#apps',5]])
        for k, v in key_values:
            print(('{0:<'+str(max_len)+'s}  {1:5d}').format(k, v))

    def list_as_is(self):
        return [(k, v) for k, v in self.counter.items()]

    def sort_by_key(self):
        return [(k, v) for k, v in sorted(self.counter.items())]

    def sort_by_value_lambda(self):
        return [(k, v) for k, v in sorted(self.counter.items(), key=lambda item : (item[1],item[0]))]

    def sort_by_value_IG(self):
        return [(k, v) for k, v in sorted(self.counter.items(), key=itemgetter(1,0))]

