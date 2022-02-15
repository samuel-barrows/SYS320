# A collection of functions that, when put together, scan a directory of
# web logs for proof of specified attacks
import os, yaml, re

def traverse(dir):
    """traverse a directory and return a list of files"""

    # check if arg is a dir
    if not os.path.isdir(dir): 
        print("invalid directory => {}".format(dir))
        exit()

    #list to save files
    fList = [] 

    # crawl through directory
    for root, subfolders, filenames in os.walk(dir):
        for f in filenames:
            filePath = root + "/" + f
            fList.append(filePath)

    return(fList)

def yamlParse(yamlfile):
    """parse yaml file"""
    # open file if possible
    try: 
        with open(yamlfile, 'r') as yamlF:
            #yaml safe load
            keywords = yaml.safe_load(yamlF)
    except EnvironmentError as e:
        print(e.strerror)
    return keywords 

def log_scan(filename, searchterms, book):
    """scan a log file and search for the search term"""
    """improved 'syslogCheck' from week2"""

    # Query yaml file for the terms in each yaml book
    # to retrieve the strings to search on
    #terms = keywords[book]
    terms = searchterms[book]

    #Open a file
    with open(filename) as f:
        #read the file lines
        contents = f.readlines()

    #List to store results
    results = []

    # scan each line for each yaml book entry
    for line in contents:
        for attack in terms:
            #if keyword in line:
            x = re.findall(r''+terms[attack]+'', line)
            # add it to the found array for later parsing
            # in other modules
            for found in x:
                results.append(line)
                
    results = sorted(results)

    return results

def fmtResults(string):
    """From string, return a pretty string"""
    sR = string.split(" ")
    print("""
    Time Stamp: {}{}\n
    URL: {}\n
    Status Code: {}\n
    Bytes: {}\n
    Source IP: {}\n
    {}
    """.format(sR[3].strip("["),sR[4].strip("]"), sR[6], sR[8], sR[9], sR[0], "*"*60).strip("\n"))