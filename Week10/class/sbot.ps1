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
