# create and interface to search through syslog files
import re
import sys
import yaml

# open file if possible
try: 
    with open('searchTerms.yaml', 'r') as yamlF:
        #yaml safe load
        keywords = yaml.safe_load(yamlF)
except EnvironmentError as e:
    print(e.strerror)

def _syslog(filename, service, term):
    
    # Query yaml file for the 'term' or 'service
    # retrieve the strings to search on
    #terms = keywords[apache][php]
    terms = keywords[service][term]
    
    listOfKeywords = terms.split(",")
    
    #Open a file
    with open(filename) as f:
        #read the file lines
        contents = f.readlines()

    #List to store results
    results = []

    for line in contents:
        for keyword in listOfKeywords:
            #if keyword in line:
            x = re.findall(r''+keyword+'', line)
            
            for found in x:
                results.append(found)
                
    if len(results) == 0:
        print("no results")
        sys.exit(1)
                
    results = sorted(results)

    return results