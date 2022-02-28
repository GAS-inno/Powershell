# import the Active Directory module in order to be able to use get-ADuser and Add-AdGroupMembe cmdlet
import-Module ActiveDirectory



# enter login name of the first user
$copy = Read-host "Enter username to copy from: "

# enter login name of the second user
$paste  = Read-host "Enter username to copy to: "

# copy-paste process. Get-ADuser membership     | then selecting membership                       | and add it to the second user
get-ADuser -identity $copy -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $paste



$yn = read-host "do you want to check the result [y/n]?"

if ($yn -eq 'y'){
            $sourceUser = get-aduser $paste -Properties memberof 

            $sourceGroups = $sourceUser.memberof 

            foreach($group in $sourceGroups) {
   
                                    #split the Array by comma "," | "="
            $thisgroup = $group.split(",")[0].split("=")[1]
            $thisGroup

        }

    else { read-host "press enter to exi"}


    }

#display result

<#
Write-Host $User = Get-ADUser -Identity $copy -Properties *;
$GroupMembership = ($user.memberof | % { (Get-ADGroup $_).Name; }) -join ';';
write-host "$User.SamAccountName + ';' + $GroupMembership; "  -ForegroundColor green


write-host $User = Get-ADUser -Identity $paste -Properties *;
$GroupMembership = ($user.memberof | % { (Get-ADGroup $_).Name; }) -join ';';
write-host "$User.SamAccountName + ';' + $GroupMembership; "  -ForegroundColor green
#>