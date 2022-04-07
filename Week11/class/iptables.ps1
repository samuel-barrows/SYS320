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

# Get the IP addresses discovered, loop and replace each line beginning with IPtables syntax
# iptables -A INPUT -s IP -j DROP

#% is foreach-object. $_ is the return value of the get-content
(Get-Content -Path ".\ips-bad.tmp") | % `
{ $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
out-file -FilePath "iptables.bash"
