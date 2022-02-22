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
                results.append(line.strip("\n") + "," + str(attack) )
                
    results = sorted(results)

    return results

def fmtResults(string, scan):
    """From string, return a pretty string"""
    sR = string.split(",")
    print("""
    Hostname: {}\n
    Program: {}\n
    Path: {}\n
    User: {}\n
    PID: {}\n
    Args: {}\n
    Details:
    {}\n
    {}
    """.format(sR[2], sR[3], sR[4], sR[6], sR[5], sR[1], mitreDetails(scan), "*"*60).strip("\n"))

def mitreDetails(string):
    """get attack type from string and return the details on that attack"""
    credcollection = """
    The Windows Registry stores configuration information that can be used by the system or other programs. Adversaries may query the Registry looking for credentials and passwords that have been stored for use by other programs or services. Sometimes these credentials are used for automatic logons.

    Adversaries could also inject malicious DLLs into registry keys that are loaded after reboot. When a user authenticates the DLLs have a routine that captures their credentials after login.

    Reference:

    https://attack.mitre.org/techniques/T1214/ (Links to an external site.)

    """
    script = """
    Adversaries may use scripts to aid in operations and perform multiple actions that would otherwise be manual. Scripting is useful for speeding up operational tasks and reducing the time required to gain access to critical resources. Some scripting languages may be used to bypass process monitoring mechanisms by directly interacting with the operating system at an API level instead of calling other programs. Common scripting languages for Windows include VBScript and PowerShell but could also be in the form of command-line batch scripts.

    References:

    Scripting: https://attack.mitre.org/techniques/T1059/ (Links to an external site.)

    MSHTA: https://attack.mitre.org/techniques/T1170/ (Links to an external site.)

    Regsvr32: https://attack.mitre.org/techniques/T1117/ (Links to an external site.)

    """
    pshell = """
    PowerShell is a powerful interactive command-line interface and scripting environment included in the Windows operating system. Adversaries can use PowerShell to perform a number of actions, including discovery of information and execution of code. Examples include the Start-Process cmdlet which can be used to run an executable and the Invoke-Command cmdlet which runs a command locally or on a remote computer.

    Reference:

    https://attack.mitre.org/techniques/T1086/ (Links to an external site.)

    """

    if string == "scripts":
        return script
    elif string == "pshell":
        return pshell
    elif string == "cred_collect":
        return credcollection

#def stats(string):
#    """Count possible unsuccessful/successful attacks"""
#    sR = string.split(" ")
#    if int(sR[8]) == 200 and int(sR[9]) > 5000:
#        return 0
#    else:
#        return 1