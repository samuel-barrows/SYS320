# List Files in a Directory
# List all Files and print full path
#Get-ChildItem -Recurse  -include *.docx,*.pdf,*.txt -Path .\Documents | select fullname

#Export to csv
#Get-ChildItem -Recurse  -include *.docx,*.pdf,*.txt -Path .\Documents | export-csv `
#-Path files.csv

# Import CSV file.
$fileList = import-csv -path .\files.csv -header FullName

#Loop through results
foreach ($f in $fileList) {

    Get-ChildItem -Path $f.FullName

}