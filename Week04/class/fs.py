 #file to traverse a given directory and it's subdirs and retrieve all files
import os, argparse

# get info from the commandline
#print(sys.argv)

#directory to traverse
#rootdir = sys.argv[1]
parser = argparse.ArgumentParser(
    description="Traverses directory and builds a forensic body file",
    epilog="Developed by Samuel barrows,20220210"
)

# add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory you want to parse.")

# Parse arguments
args = parser.parse_args()

rootdir = args.directory

# traverse a directory
# check if arg is a dir
if not os.path.isdir(rootdir): 
    print("invalid directory => {}".format(rootdir))
    exit()

#list to save files
fList = [] 

# crawl through directory
for root, subfolders, filenames in os.walk(rootdir):
    for f in filenames:
        filePath = root + "/" + f
        fList.append(filePath)

#print(fList)

def statFile(toStat):
    # i is going to be the variable used for each of the metadata elements
    i = os.stat(toStat, follow_symlinks=False)

    # mode
    imode = i[0]

    # inode
    inode = i[1]

    # uid
    uid = i[4]

    # gid
    gid = i[5]

    # filesize
    fsize = i[6]

    #access time
    atime = i[7]

    # mod time
    mtime = i[8]

    # c time => unix==change time
    ctime = i[9]
    crtime = i[9]

    print("0|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}".format(toStat, inode, imode, uid, gid, fsize, atime, mtime, ctime, crtime))

for eachFile in fList:
    statFile(eachFile)