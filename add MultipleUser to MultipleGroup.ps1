
#$user=read-host -Prompt 'Enter user names to add to group'
#below code will promt a window box to find the group in AD
#$groups =  Get-ADgroup -Filter * | Select-Object -Property Name| Out-GridView -PassThru -Title 'Select the Groups you want to add the users' | Select-Object -ExpandProperty Name

##--------------- 1st method--------------------


#get user/group from arraylist

$user_array = @('dnguyenlinh', 'hanguyenthi')
#$VN_groups_array = @('VNGUWIF', 'VNGDEmployeesVietnam', 'VNGUVPN', 'VNGDUsers', 'VNGUJiraUsers','VNGUConfluenceUsers','SGGUEXCLIC')  
$VN_groups_array = @('VNGUVPN', 'VNGUJiraUsers','VNGUConfluenceUsers') 


foreach ($User in $user_array){
    foreach($group in $VN_groups_array){
        Add-ADGroupMember -Identity $group -Members $user #-WhatIf
        } 

        write-host "added $user_array to $VN_groups_array"
}



###-----------------   2nd method ------------------------

<#
#get user/group from text files
#user name suppose to be in SamAccountName 
#if you only have user fullname are given. pls use the 2nd for loop script.

$Users = Get-Content "C:\temp\users.txt"

$Groups = Get-Content “C:\temp\groups_SG.txt”


foreach ($User in $Users){
    foreach($group in $Groups){
        Add-ADGroupMember -Identity $group -Members $user

        write-host ("the user $user is added to ") -NoNewline
        write-host ("$group ") -ForegroundColor green
        } 
}


#>


#---2nd for loop --> when you only have userfullname 
<#
foreach ($User in $Users){
foreach ($Group in $Groups)
{
$Sam = (Get-ADUser -Filter {Name -like $User}).SamAccountName
write-host “Added $User ID: $Sam to $Group” -ForegroundColor Green
Add-ADGroupMember -Identity $Group -Members $Sam
}
}

#>

<#
#check the recent added group
$check_user=read-host -Prompt 'Enter user names to check'

(Get-ADUser $check_user –Properties MemberOf).memberof | Get-ADGroup | Select-Object name
#>
