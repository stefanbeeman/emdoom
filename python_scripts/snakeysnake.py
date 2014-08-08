import sys
import numpy as np

def foobar():
    print "whoa"
    sys.stderr.write("meh\n")
    print np.dot([1,2,3],[4,5,6])
    return 0
