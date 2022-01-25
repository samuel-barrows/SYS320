# create and interface to search through syslog files
import re
import sys

def _syslog(filename,keywords):
    
    #Open a file
    with open(filename) as f:
        #read the file lines
        contents = f.readlines()

    #List to store results
    results = []

    for line in contents:
        for keyword in keywords:
            #if keyword in line:
            x = re.findall(r''+keyword+'', line)
            
            
            for found in x:
                results.append(found)
                
                
    if len(results) == 0:
        print("no results")
        sys.exit(1)
                
    results = sorted(results)

    return results