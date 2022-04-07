clear
# Login to a remote SSH server
# New-SSHSession -ComputerName "10.0.78.3" -Credential (Get-Credential sam-adm)

<#
while ($True) {
    # Add a prompt to rum commands
    $the_command = read-host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $the_command).Output
}
#>

Set-SCPItem -computername '10.0.78.3' -credential (Get-Credential sam-adm)`
-Destination '/home/sam-adm' -Path '.\lol.txt'
