import syslogCheck
import importlib
importlib.reload(syslogCheck)
# SSH successful logins

def ssh_success(filename, searchTerms):
    # 
    is_found = syslogCheck._syslog(filename,searchTerms)
    
    found = []
    
    for eachFound in is_found:
        splitResults = eachFound.split(' ')
        found.append(splitResults[5])
        
            
    for item in set(found):
        print(item)