do {
$email =  read-host "`nenter user email address: " #$user.email
$mailbox = Get-Mailbox -Identity $email
$DN=$mailbox.DistinguishedName
$Filter = "Members -like ""$DN"""
$DistributionGroupsList = Get-DistributionGroup -ResultSize Unlimited -Filter $Filter #|sort-object name
Write-host `n
Write-host "Listing all Distribution Groups:"
Write-host `n
$DistributionGroupsList | FT #Export-csv -Path C:\output.csv -NoTypeInformation

$yesno = read-host 'Do you want to continue [y/n]?: '

} while ($yesno -eq 'y')