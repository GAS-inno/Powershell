$ADUsers = Import-csv "C:\Users\xxx\powershell\script_csv_template\bulk_users1.csv"


#add extentionaAttribute - SG
$ADUsers |ForEach-Object { Set-ADUser -Identity $_.username -add @{extensionAttribute2 = "SG"}}

#pause

#$ADUsers |ForEach-Object { Set-ADUser -Identity $_.username -add @{Proxyaddresses = $_.Proxyadddresses}}

$ADUsers |ForEach-Object { Set-ADUser -Identity $_.username -add @{Proxyaddresses = "SMTP:"+$_.email} }
#$ADUsers |ForEach-Object { Get-Recipient $_.username }
