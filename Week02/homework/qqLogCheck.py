import syslogCheck
import re
import importlib
importlib.reload(syslogCheck)
# Parse Proxifier logs to find results of QQ threats 

def log_search(filename, service, term):
    is_found = syslogCheck._syslog(filename, service, term)
    
    found = []
    
    for eachFound in is_found:
        splitResults = eachFound.split(' ')
        # Print out the found results
        if term == 'qqbytes' and "KB)" in splitResults[9]:
            found.append(splitResults[2] + " " + splitResults[4] + " sent:" + splitResults[6] + " recieved:" + splitResults[11])
        elif term == 'qqbytes':
            found.append(splitResults[2] + " " + splitResults[4] + " sent:" + splitResults[6] + " recieved:" + splitResults[9])
        elif term == 'qqopen':
            found.append(splitResults[2] + " opened to: " + splitResults[4] + " with: " + splitResults[9])
        
            
    for item in set(found):
        print(item)
    