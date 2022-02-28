$groupname = "SGGUEXCLIC"
#$companyname = '*'
$users = Get-ADGroupMember -Identity $groupname | ? {$_.objectclass -eq "user"}
$result = @()
$Properties= @('Name', 'SamAccountName', 'UserPrincipalName', 'EmailAddress', 'memberof', 'company')

foreach ($activeusers in $users) { $result += (Get-ADUser -Identity $activeusers -Properties $Properties | ? {$_.enabled -eq $true} | ? {$_.company -eq $companyname } | select Name, SamAccountName, UserPrincipalName,EmailAddress, Enabled, company, @{Name='MemberOf';Expression={$_.MemberOf -join ';'}} ) }
$result | Export-CSV -NoTypeInformation 'C:\Users\gasaw\OneDrive - INGENICO Group\powershell\TaskSchedularFiles\FPT_O365mailbox_v2.csv'
