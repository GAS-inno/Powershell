# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory

$LogDate = get-date -f dd-MM-yyyy_HHmmffff

$rootpath = "C:\temp"
# Location of CSV file that contains Users information
#$path = "$rootpath\powershell\csv\AD_Activation_Date.csv"
$path = import-csv -Path (Get-ChildItem -Path "$rootpath\powershellscript\csv\"  -Filter '*.csv').FullName | Where-Object {($_.upn -ne '') -and ($_.action -eq 'create')}

$ImportPath= $path

# Location of CSV fle that will be exported to including random passwords
$ExportPath = "$rootpath\powershellscript\pwd\Passwords_$logDate.csv"

# Define UPN

# Store the data from $path locationcsv in the $ADUsers variable
$ADUsers = $ImportPath

# Randomize passwords
function Get-RandomPassword {
    Param(
        [Parameter(mandatory = $true)]
        [int]$Length
    )
    Begin {
        if ($Length -lt 4) {
            End
        }
        $Numbers = 1..9
        $LettersLower = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
        $LettersUpper = 'ABCEDEFHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
        $Special = '!@#$%^&*()=+[{}]/?<>'.ToCharArray()

        # For the 4 character types (upper, lower, numerical, and special)
        $N_Count = [math]::Round($Length * .2)
        $L_Count = [math]::Round($Length * .4)
        $U_Count = [math]::Round($Length * .2)
        $S_Count = [math]::Round($Length * .2)
    }
    Process {
        $Pswrd = $LettersLower | Get-Random -Count $L_Count
        $Pswrd += $Numbers | Get-Random -Count $N_Count
        $Pswrd += $LettersUpper | Get-Random -Count $U_Count
        $Pswrd += $Special | Get-Random -Count $S_Count

        # If the password length isn't long enough (due to rounding), add X special characters
        # Where X is the difference between the desired length and the current length.
        if ($Pswrd.length -lt $Length) {
            $Pswrd += $Special | Get-Random -Count ($Length - $Pswrd.length)
        }

        # Lastly, grab the $Pswrd string and randomize the order
        $Pswrd = ($Pswrd | Get-Random -Count $Length) -join ""
    }
    End {
        $Pswrd
    }
}

# Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers) {

    # Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = Get-RandomPassword -Length 9
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $Extname    = $User.Extname
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $email = $User.email
    $upn   = $user.upn
    $streetaddress = $User.streetaddress
    $city = $User.city
    $country    = $User.country
    $manager = $User.manager
    $zipcode = $User.zipcode
    $state = $User.state
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $description= $User.description
    $department = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F {(SamAccountName -eq $Username) -or (Emailaddress -eq $email)}) {
    #if (Get-ADUser -F { SamAccountName -eq $username }) {

        # If user does exist, give a warning
        Write-Warning "A user account with username $username | $email | $upn already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$upn" `
            -Name "$firstname $lastname $Extname"  ` <# ($EXTname) -Name "$Firstname $Lastname (Ext-Landi)" ` #>`
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$firstname $lastname $Extname" ` <# -DisplayName "$Firstname $Lastname (Ext-Landi)" ` #>`
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Company $company `
            -Country $country `
            -Manager $manager `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -Description $description `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) -ChangePasswordAtLogon $True

            Set-ADUser -Identity $username -add @{extensionAttribute2 = "$country"}
            #Set-ADUser -Identity $username -add @{Proxyaddresses = "SMTP:"+$_.upn}

     
        # If user is created, show message
       # Write-Host "The user account $username is created." -ForegroundColor Cyan
        write-host $User.firstname $User.lastname "|" $User.username created -ForegroundColor cyan 
        $User | Add-Member -MemberType NoteProperty -Name "Random Generated Password" -Value $password -Force
       # $User | Add-Member -MemberType NoteProperty -Name "test" -Value $Extname -Force
    }

    # Export
    $ADUsers | Export-Csv -Encoding UTF8 $ExportPath -NoTypeInformation 
}

 #add membership
          $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
          & $scriptDir\1_T_ADD_MultipleUser_to_Multiple_ADGroup_byUPN_V2.1_split_group.ps1
        #  & $scriptDir\1_T_ADD_MultipleUser_to_Singel_DLGroup_byUPN_V1_taskschedular.ps1
          
#get-aduser -Identity $_.username -Properties * |select name, extensionAttribute2, proxyaddresses


