
#$user=read-host -Prompt 'Enter user names to add to group'
#below code will promt a window box to find the group in AD
#$groups =  Get-ADgroup -Filter * | Select-Object -Property Name| Out-GridView -PassThru -Title 'Select the Groups you want to add the users' | Select-Object -ExpandProperty Name

#add  to ArrayList
$user_array = @('user1', 'user2','user3')


# OR you can put it in a txt file, your choice
 # $Users = Get-Content "B:\users.txt"

$VN_groups_array = @('group1', 'group2')  

foreach ($User in $user_array){
    foreach($group in $VN_groups_array){
        Add-ADGroupMember -Identity $group -Members $user -WhatIf
        } 
}


write-host ("the user $user_array is added to") 
write-host ("$VN_groups_array") -ForegroundColor green -NoNewline
# Red -BackgroundColor Yellow -NoNewline

Write-Host "`n You are looking " -NoNewline
Write-Host "AWESOME" -ForegroundColor green -NoNewline
Write-Host " today"


#check the recent added group
$check_user=read-host -Prompt 'Enter user names to check'

(Get-ADUser $check_user –Properties MemberOf).memberof | Get-ADGroup | Select-Object name