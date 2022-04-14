# Create commandline parameters to copy a file and place into an evidence dir
param(

    [Parameter(Mandatory = $true)]
    [int]$reportNo,

    [Parameter(Mandatory = $true)]
    [String]$filePath

)

# Create a directory with report number
$reportDir = "rpt$reportNo"

# creating a new directory
mkdir $reportDir

# copy the file into the new directory
copy-item $filePath $reportDir