#Every line was fixed to be indented properly

import csv
#imported the regular expression library
import re

#Changed the '1' here to be the lowercase 'l'
#This is the function declaration
def urlHausOpen(filename, searchTerm):
    #Opens the file and assigns the open file to 'f'
    #unquoted 'filename' so open can open the actual file
    with open(filename) as f:
        #stores the output of the csv.reader method into contents
        #changed the method name to reader rather than 'review'
        contents = csv.reader(f)
        #skips the initial comments in the csv file
        for _ in range(9):
            next(contents)
        #Loops through all the files in each line
        #Switched these two for loops around. Doesn't really fix anything
        for eachLine in contents:
        #Loops through the keywords given to the function
            for keyword in searchTerm:
                #Fixed the regular expression
                #Find if the keyword is in line
                x = re.findall(keyword, eachLine[2])
                #For each section of the line
                for _ in x:
                # Don't edit this line. It is here to show how it is possible
                # to remove the "tt" so programs don't convert the malicious
                # domains to links that an be accidentally clicked on.
                    the_url = eachLine[2].replace("http", "hxxp")
                    the_src = eachLine[4]
                    #print the details we care about formatted.
                    #changed to % syntax and changed the '+' to '*' to actually print
                    #multiple
                    print("""
                    URL: %s 
                    Info: %s 
                    %s""" % (the_url, the_src, "*"*60))

""" Answers to the questions
    1. https://docs.python.org/3.9/library/csv.html
    2. You can specify the delimiter upon creating the reader object: csv.reader(file, delimiter=DELIMITER)
    3. You can specify the csv writer object to quote fields as to escape the comma: csv.QUOTE_ALL
    4. "heredocs" have two purposes: a multi line string, or a multi line comment, or a docstring.
"""