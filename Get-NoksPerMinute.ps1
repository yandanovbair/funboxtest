[CmdletBinding()]
param(

    #Path to the file
    [Parameter(Mandatory=$false)]
    [string]$FilePath='events.log',

    #regular expression for search pattern
    [Parameter(Mandatory=$false)]
    [regex]$SearchPattern='\s\bNOK\b$',

    #regular expression for log timestamps
    [Parameter(Mandatory=$false)]
    [regex]$DatePattern='\d{4}-\d{2}-\d{2}\s\d{2}\:\d{2}\:\d{2}'
)

#main part
[System.Collections.ArrayList]$EventsPerMinute = @()

#Parsing log file line by line
foreach($line in Get-Content $FilePath) {
    #work on the lines which contain timestamps
    if($line -match $DatePattern) {
        #try to convert timestamps into the known date format
        try {
            $DateLine=Get-Date $matches[0]
        }
        #warn user if date format couldn't be processed by Powershell
        catch {
            Write-Output "Date processing failed, likely date pattern couldn't be accepted by Get-Date commandlet"
            Write-Output $_
        }
        #gather lines with found search pattern into array with dates in minute format
        if ($line -match $SearchPattern) {
            $DateLineMinute=$DateLine.ToString("yyyy:MM:dd HH:mm")
            $EventsPerMinute.Add($DateLineMinute)
        }
    }
}
#Display the amount of found records per each minute where it happened

$EventsPerMinute | Group-Object






