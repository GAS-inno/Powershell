#-------Get user samacountname by Fullname---
$Users = Get-Content 'C:\temp\userlist.txt'

#$FirstName = Read-Host "Please provide the Fist name of the User: "
#$LastName = Read-Host "Please provide the Last name of the User: "
#$Fullname = "$FirstName $LastName"
#$Users= Get-AdUser -Filter {name -like $_.FullName} -Properties * | Select Name, Samaccountname | Sort-Object -Verbose


#Get-AdUser -Filter {name -like $Users} -Properties * | Select Name, Samaccountname | Sort-Object -Verbose

#$Users




#--------Get user fullname by SamAccountName------



$Users = Get-Content "C:\temp\userlist.txt"

$users | ForEach-Object {
    Get-ADUser -ldapfilter "(samaccountname=$_)" -Property * | Select-Object -Property Givenname, surname , mail,company  |FT 
} #| Export-Csv -Path C:\temp\export.csv -NoTypeInformation
