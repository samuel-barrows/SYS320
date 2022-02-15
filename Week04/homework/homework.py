import argparse 
from fs2 import yamlParse, traverse, log_scan, fmtResults, stats

parser = argparse.ArgumentParser(
    description="Traverses directory and scans log files for web attacks",
    epilog="Developed by Samuel barrows,20220210"
)

# add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory you want to parse.")
parser.add_argument("-s", "--scanfor", required="True", help="The type of attack you want to scan for.")

# Parse arguments
args = parser.parse_args()

searchterms = yamlParse("searchterms.yaml")

# directory to traverse
rootdir = args.directory
# yaml book
book = args.scanfor

fList = traverse(rootdir)
# Track stats
sA = []
uA = []

for eachFile in fList:
    results = (log_scan(eachFile, searchterms, book))
    for x in results:
        fmtResults(x)
        # Keep track of Successful Attacks (sA) and
        # Unsuccessful Attacks (uA)
        stat = stats(x)
        if stat == 0:
            sA.append(x)
        elif stat == 1:
            uA.append(x)

print("""
    {}\n
    {}
    {}
""".format("*"*27 + "STATS" + "*"*28, 
           "Successful: {}".format(len(sA)), 
           "Unsuccessful: {}".format(len(uA))
          )
    )
print("Successful logs: ")
for x in sA:
    print(x)

