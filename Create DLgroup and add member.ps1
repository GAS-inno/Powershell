#Input request
$DLname= read-Host "Enter Distribution name"
$DLmailaddress= Read-Host "Enter PrimarySmtpAddress mail"



#create new DL group and add Attribute2 SG
New-DistributionGroup -Name $DLname -Alias $DLname -PrimarySmtpAddress $DLmailaddress |Set-DistributionGroup -CustomAttribute2 SG

#check if Attribute2 is added SG
Get-DistributionGroup $DLname | FT CustomAttribute2


pause

#import member from CSV
import-csv C:\Users\gasaw\Downloads\add_distributionMember.csv | foreach {add-distributiongroupmember -id $DLname -member $_.PrimarySmtpAddress } -WhatIf