import sys
import fileinput

in_file = False

for line in fileinput.input():
    if line.startswith(">"):
        # Close current file
        if in_file:
            f.close()

        # Make new filename
        fname = line.rstrip().partition(">")[2]
        fname = "%s.fa" % fname

        # Open new file
        f = open(fname, "w")
        in_file = True

        # Write current line
        f.write(line)

    elif in_file:
        # Write line to currently open file
        f.write(line)

    else:
        # Something went wrong, no ">chr1" found yet
        print >>sys.stderr, "Line %r encountered, but no preceeding > line found"
