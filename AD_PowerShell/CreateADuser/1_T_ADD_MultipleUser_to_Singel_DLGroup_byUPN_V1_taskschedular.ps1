

$Logfile = "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\myproj\log_script.log"
function WriteLog
{
Param ([string]$LogString)
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$LogMessage = "$Stamp $LogString"
Add-content $LogFile -value $LogMessage
}


$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
& $scriptDir\Exchange_Online_Powershell_Access.ps1


#Start-Transcript -Append "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\log_script.log"

#$file = Import-CSV "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\myproj\csv\AD_Activation_Date.csv"

$rootpath = "c:\temp"
$csvfiles = import-csv -Path (Get-ChildItem -Path "$rootpath\powershellscript\csv"  -Filter '*.csv').FullName | Where-Object {($_.group2 -ne '') -and ($_.action -eq 'addmemember' -or $_.action -eq 'create')}

#import csv file and assigned variable to $file
       
        
 #import csv file and assigned variable to $file
#$file = Import-CSV "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\myproj\csv\AD_Activation_Date.csv"# "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\add_azureADGroupMember_anygroupname.csv"
       
        
 #import csv file and assigned variable to $file
       
    $csvfiles | ForEach-Object{     
 #Foreach ($user in $file) { 
      
       $check1 =  Get-DistributionGroupMember -Identity $_.group |select name, PrimarySmtpAddress |sort-object name, PrimarySmtpAddress
             #where-object {$_.PrimarySMTPAddress -eq '$_.User'}

            
          
      if ($check1.PrimarySmtpAddress -contains $_.upn){
        write-host "$($_.upn) is already a member of [ $($_.group) ] !" -ForegroundColor red

          $_.upn |  Out-GridView
        }

       else{
               Add-DistributionGroupMember -Identity $_.group -Member $_.upn 
                #remove-ADGroupMember -Identity $group -Members $ADUser.SamAccountName  -Confirm:$false
                 write-host "$($_.upn) is successfully added to [ $($_.group) ] !" -ForegroundColor green
                       
                             }          


 }#end foreach loop



                    
                           