
$ADUsers = Import-csv "C:\temp\DevicesWithInventory_6db9330a-4377-4057-bc86-837f55fee3f6.csv"
#$ADUsers = Import-csv "C:\temp\Passwords_04-02-2022_16027419.csv"


$result = ForEach ($user in $ADUsers) {
    $email= $user.PrimaryuserUPN

   get-aduser -Filter {emailaddress -eq $email} -Properties mail | select name,mail, whencreated, company,cn,country  
   }  
   
   
    $result #| Export-Csv -path c:\temp\intune_add_country.csv -NoTypeInformation
  