
#count any ADgroup name. prompt you to ask for next action.

write-host "`n=============================================================" 
write-host "======= Count any ADGroupmember | Export Disable user ======="-foregroundcolor yellow
write-host "============================================================="

    do 
        {   $group=read-host -Prompt 'What is  the name of the ADGroup you want list members of?'

            $Enabled_Users= (Get-ADGroupMember $group| Get-ADuser | Where-Object {$_.Enabled -eq $true} |select Name ).count
            $Disabled_Users= (Get-ADGroupMember $group| Get-ADuser | Where-Object {$_.Enabled -ne $true} |select Name ).count
            $total = 0  #to hold the user input
            #$groups =  Get-ADgroup -Filter * | Select-Object -Property Name| Out-GridView -PassThru -Title 'Select the Groups you want to add the users' | Select-Object -ExpandProperty Name

            #count active user
            write-host "`n========================================"
            write-host $group
            Write-Host "Enabled user  :" $Enabled_Users -ForegroundColor green
            write-Host "Disabled user :" $Disabled_Users -ForegroundColor yellow

            $total += $Enabled_Users+$Disabled_Users
            write-host "total :" $total

            write-host "`n"
            $yn_listDisableUser = Read-Host -prompt "Do you want to view who are the DISABLED USERS? [y/n]: "
                if ($yn_listDisableUser -eq 'y') 
                    {
                        write-host "`n========================================" 
                        write-host "======= Disabled USER list ============="-foregroundcolor yellow
                        write-host "========================================"
                                    
                        #check who are the disabled users?
                       Get-ADGroupMember  $group | Get-ADuser -Properties * | Where-Object {$_.Enabled -ne $true} |Select-Object Name ,SAMAccountName, country, co, UserPrincipalName, extensionAttribute2, enabled |Format-Table
                                   
                    }
                else {write-host 'you have cancelled'}
            
         
           #export csv file?
           $yn_export = Read-Host -prompt 'Do you want to export the disabled user list in CSV file [Y/N]? :'
            if ($yn_export -eq 'y') { 

                      Get-ADGroupMember  $group | Get-ADuser -Properties * | Where-Object {$_.Enabled -ne $true} |Select-Object Name ,SAMAccountName, country, co, UserPrincipalName, extensionAttribute2, enabled | 
                      Export-Csv -Path "C:\temp\disableduserList.csv" -NoTypeInformatio
            }

            else { write-host "`nyou have cancelled"}


            #prompt input
                $yesno = Read-Host -prompt 'Do you want another groupmember count [Y/N]?: '
                   
        } while($yesno -eq 'y')
   




#--- 

#prompt input

#-- check with user name ---
<#
$group=read-host -Prompt 'Enter group names to add to count'

#get active user from the group
Get-ADGroupMember $group|  Get-ADuser | Where {$_.Enabled -eq $true} | select Name |FT
#>


#2nd method to pipe the AD group with members properties
<#
$groupName = read-host "What is the name of the AD Group you want list members of?"

Get-ADGroup -Identity $groupName -Properties members |
Select-Object -ExpandProperty members |
Get-ADUser  |
Where-Object -Property enabled | FT
#>