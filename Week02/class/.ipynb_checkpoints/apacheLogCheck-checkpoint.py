import syslogCheck
import importlib
importlib.reload(syslogCheck)
# SSH authentication failure checks

def apache_events(filename, service, term):
    # call syslogCheck to query the apache log
    is_found = syslogCheck._syslog(filename, service, term)
    
    found = []
    
    for eachFound in is_found:
        splitResults = eachFound.split(' ')
        found.append(splitResults[0] + " " + splitResults[1] + " " + splitResults[2] + " " + splitResults[3])
        
            
    for item in set(found):
        print(item)