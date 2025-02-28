#group split with ';' in csv

#$ErrorActionPreference = "SilentlyContinue"


#$file = Import-CSV "C:\Users\wagasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\myproj\csv\AD_Activation_Date.csv"
$rootpath = "c:\temp"
$csvfiles = import-csv -Path (Get-ChildItem -Path "$rootpath\powershellscript\csv"  -Filter '*.csv').FullName | Where-Object {($_.group2 -ne '') -and ($_.action -eq 'addmember' -or $_.action -eq 'create')}

$csvfiles | ForEach-Object {
     
  


     #  Try{
            #   Write-host "Checking $($_.upn) in $($_.group2)..........  " -ForegroundColor cyan
                              
               #ForEach ($user in $file) {
                    # Retrieve UPN
                   $email = $_.upn #whatever your field name
                   $groups = $_.group2
         
                    # Retrieve UPN related SamAccountName
                   $ADUser = Get-ADUser -Filter "mail -eq '$email'" | Select-Object SamAccountName,name

                foreach ($group in $groups.Split(';')) {

                        $check2 = Get-ADGroupMember -Identity $group | Get-ADUser -Properties * | select Name, samaccountName, userPrincipalName

                    if ($check2.userPrincipalName -contains $_.upn){
                        write-host "$($_.upn) is a member of $group !" -ForegroundColor red
                            }

                    else {

                       Add-ADGroupMember -Identity $group -Members $ADUser.SamAccountName -ErrorAction SilentlyContinue
                      # remove-ADGroupMember -Identity $group -Members $ADUser.SamAccountName  -Confirm:$false
                        write-host "$($_.upn) is successfully added to $group !" -ForegroundColor green
                        }
                       
                     } #END foreach loop
 
            }
#} #main *csf file loop end
  <# catch{
                Write-Warning "Exception String: $($_.Exception.Message)"
                }

                #>

#}