# Array of websites containing threat intel
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules', 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {
    #Extract the file name
    $temp = $u.split("/")
    #Get last element of the array for the file name
    $file_name = $temp[-1]

    if (Test-Path $file_name){
        continue
    }  else {
        #Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name
    }
}

#Array containing filenames
$input_paths = @('.\compromised-ips.txt', '.\emerging-botcc.rules')

#Extract IP addresses
# 10.10.10.10
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP address to the temp IP list
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches }  | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

function Scp-File ($file) {
    # SCP a file over to a remote machine
    Write-Host "Please enter the IP address of the remote server"
    $ip = Read-Host

    Write-Host "Please enter the user on the remote server"
    $user = Read-Host

    try {
        Set-SCPItem -computername $ip -credential (Get-Credential $user)`
        -Destination "/home/sam-adm" -Path $file
    } catch {
        write-host $_
    }
}

function iptables {
    # Get the IP addresses discovered, loop and replace each line beginning with IPtables syntax
    # iptables -A INPUT -s IP -j DROP

    #% is foreach-object. $_ is the return value of the get-content
    (Get-Content -Path ".\ips-bad.tmp") | % `
    { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
    out-file -FilePath "iptables.bash"

    If (Test-Path "iptables.bash"){
        Write-Host "File Created!"
    } Else {
        Write-Host "File Not Created"
        Exit
    }
    #Copy the file over to our remote system
    Write-Host "Would you like to copy this file over to a remote system (y/n)?"
    $option = Read-Host

    switch ($option) {
        "y" {Scp-File(".\iptables.bash"); Break}
        "n" {Break}
    }
}

function windowsFirewall {
    # Get IP addresses discovered, loop and replace each line and block ips in windows firewall
    # New-NetFirewallRule -DisplayName "Block IPADDR out" -Direction Outbound -Profile Any -Action Block -RemoteAddress IPADDR
    # New-NetFirewallRule -DisplayName "Block IPADDR in" -Direction Inbound -Profile Any -Action Block -RemoteAddress IPADDR

    (Get-Content -Path ".\ips-bad.tmp") | % `
    { "New-NetFirewallRule -DisplayName 'Block $_ out' -Direction Outbound -Profile Any -Action Block -RemoteAddress $_"; `
      "New-NetFirewallRule -DisplayName 'Block $_ in' -Direction Inbound -Profile Any -Action Block -RemoteAddress $_" } | `
    out-file -FilePath "wf.ps1"

    If (Test-Path "wf.ps1"){
        Write-Host "File 'wf.ps1' Created!"
    } Else {
        Write-Host "File Not Created"
        Exit
    }
}

clear-host

# Menu
Write-Host "Would you like to create an iptables [iptables] script or a windows firewall [windows] script?"
$f_option = Read-Host

try {
    switch ($f_option) {
        "iptables" { iptables; Break}
        "windows" {windowsFirewall; Break}
        # If the user misinputs, tell them the proper syntax
        default {throw "Please enter either 'iptables' or 'windows'"}
    }
} catch {
    # Write the error to stdout
    Write-Host $_
}
