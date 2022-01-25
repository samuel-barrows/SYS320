import syslogCheck
import sys
import importlib
importlib.reload(syslogCheck)
# KloginD failure detection

def klogin_fail(filename, searchTerms):
    # 
    is_found = syslogCheck._syslog(filename,searchTerms)
    
    found = []
    
    for eachFound in is_found:
        splitResults = eachFound.split(' ')
        # Split the results for the klogind for IP and reason
        found.append("%s reason: %s %s" % (splitResults[4], splitResults[6], splitResults[7]))
        
    for item in set(found):
        print(item)