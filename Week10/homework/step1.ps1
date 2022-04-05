# Function to verify the creation of files
function testFor(){
    If ( Test-Path $out ){
        Write-Host -BackgroundColor "Green" -ForegroundColor "White" "File was copied"
    } Else {
        Write-Host -BackgroundColor "Red" -ForegroundColor "White" "File was not created"
    }
}

# Copy Powershell to the user dove's directory
$out = "C:\Users\dove\EnNoB-8213.exe"
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Destination $out
testFor($out)

# Write the ransom note to the users desktop
$out = "C:\Users\dove\Desktop\Readme.READ"
Write-Output "If you want your files restored , please contact me at dunston@champlain.edu. I look forward to doing business with you." | out-file -file $out
testFor($out)