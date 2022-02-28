#Store the data from ADUsers.csv in the $ADUsers variable  # column header name "username"


write-host "`n=============================================================" 
write-host "======= ADD and Remove to a Groupmembership ======="-foregroundcolor yellow
write-host "============================================================="



#----------Function Index menu-----------------
function Show-Menu {
    param (
        [string]$Title = 'Bluk user Add and Remove to a Group' 
    )
    Clear-Host
    Write-Host "================ $Title ================"

    Write-Host "`n1: Press '1' ADD user to Group"
    Write-Host "2: Press '2' Remove user from Group"
    Write-Host "`nQ: Press 'Q' to quit.`n"
}

do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"

    switch ($selection)
    {

    '1' {      write-host  'You chose option #1 =>  ADD user to Group' -ForegroundColor Yellow 
                             
                             
                             #import the file                                      
                           $Import = Import-csv "C:\temp\Passwords_04-02-2022_16027419.csv"


                            #importing user 
                           write-host = "importing user"
                           $getcontent =  Get-Content -Path 'C:\temp\Passwords_04-02-2022_16027419.csv' | ConvertFrom-CSV | Select-Object 'username', email, upn
                            $getcontent
                               

                                
                               $groupname = read-host 'enter the group name'


                            #  $getcontent =  Get-Content -Path 'C:\temp\Passwords_04-02-2022_16027419.csv' | ConvertFrom-CSV | Select-Object username, email, upn
                            $getcontent

                              #validate Yes/No
                        $validation = Read-Host -Prompt "`n Do you want to run above script? `nPlease confirm the import user file is correct? [y/n]"
                                
                                
                                if ( $validation -match "[yY]" ) { 
                                    
                                     #----Add to group

                                $Import | ForEach-Object {add-ADGroupMember -Identity $groupname -Members $_.username
                                Get-ADUser -Identity $_.username
                                write-host (" $($_.username))  |added to $groupname `n ") -ForegroundColor Green } 


                                    
                                }
                    
                
                 }
   
    '2' {      write-host 'You chose option #2 =>  Add Multiple user list from CSV.' -ForegroundColor Yellow

                    #read the content of the script file
                   #$getcontent =  Get-Content -Path '.\Desktop\script_csv_template\'
                   
                    #write-host = " $getcontent" -ForegroundColor Green

                        $validation = Read-Host -Prompt "`n Do you want to run above script? [y/n]"
                                if ( $validation -match "[yY]" ) { 
                                    # Highway to the danger zone 
                                     &'.\Bulk_create_user__modify.ps1'
                                }

                                write-host 'added  user'

            } 

    }
  
   pause   #press enter to continue 
   
 }
 until ($selection -eq 'q')

<# 
$Import = Import-csv ".\Documents\add_distributionMember.csv""
$groupname = "vngdacchanoi"


 #----Add to group

$Import | ForEach-Object {add-ADGroupMember -Identity $groupname -Members $_.PrimarySmtpAddress
Get-ADUser -Identity $_.SamAccountName
write-host (" $($_.name)  |added to $groupname `n ") -ForegroundColor Green } 



 #-----remove from group member

<#
$Import | ForEach-Object {remove-ADGroupMember -Identity $groupname -Members $_.SamAccountName -Confirm:$False
Get-ADUser -Identity $_.SamAccountName -Properties extensionAttribute2 | Set-ADUser -Clear "extensionAttribute2"
write-host (" $($_.name)  |removed from $groupname `n ") -ForegroundColor Green } 
#>

 