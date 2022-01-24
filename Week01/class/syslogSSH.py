import syslogCheck
import importlib
importlib.reload(syslogCheck)
# SSH authentication failure checks

def ssh_fail(filename, searchTerms):
    # 
    is_found = syslogCheck._syslog(filename,searchTerms)
    
    found = []
    
    for eachFound in is_found:
        splitResults = eachFound.split(' ')
        found.append(splitResults[8])
        
            
    for item in set(found):
        print(item)