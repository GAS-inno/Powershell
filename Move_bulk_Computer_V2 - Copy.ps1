#$Credentials = Get-Credential

#Get-ADUser wagasaw -Properties DistinguishedName -Credential $Credentials
function WriteLog
{
    Param ([string]$LogString)
    $LogFile = "C:\Users\moveSGcomputer.log"
    $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    $LogMessage = "$Datetime $LogString"
    Add-content $LogFile -value $LogMessage
}



$ComputersPath= Import-Csv -Path "C:\Users\SGcomputer.csv"
$TargetOU = "OU=Workstations,OU=Singapore,OU=Singapore,OU=Tier....xxx"

foreach ($item in $ComputersPath){

    $computer = Get-ADComputer $item.Name

    Move-ADObject -Identity $computer.DistinguishedName -TargetPath $TargetOU

    Write-Host Computer account $computer.Name has been moved successfully -BackgroundColor Green
	
   WriteLog "$computer  moved to  $TargetOU" 
		}
