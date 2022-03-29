# Get list of running processes

#$outputName = "C:\Users\dove\Documents\SYS320\Week9\service.csv"

# Get list of memebers
#Get-process | Get-member

# Get a list of process: name, id, path
#Get-Process | select ProcessName, id, path  

# Save the output to a csv file
Get-Process | select ProcessName, id, path | Export-Csv -Path `
"C:\Users\dove\Documents\SYS320\Week9\process.csv"

# System Services
#Get-Service | get-member
#Get-service | select Status, Name, DisplayName, BinaryPathName | export-csv -Path `
#$outputName

# Get a list of running services
#Get-service | Where-Object { $_.Status -eq "running" } | export-csv -Path $outputName

# check if file exists
#If ( Test-Path $outputName ){
#    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "Services file was created"
#} Else {
#    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "Services file was not created"
#}
