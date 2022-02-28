# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory

$LogDate = get-date -f dd-MM-yyyy_HHmmffff

# Location of CSV file that contains Users information
$ImportPath= 'C:\Users\gasaw\OneDrive - INGENICO Group\powershell\script_csv_template\bulk_users1.csv'
#$ImportPat = Import-csv 'C:\Users\gasaw\OneDrive - INGENICO Group\powershell\script_csv_template\CSV Files\External_users1.csv'
#$ImportPath= 'C:\Users\gasaw\OneDrive - INGENICO Group\powershell\script_csv_template\CSV Files\VN_Contractor_users.csv'


# Location of CSV fle that will be exported to including random passwords
$ExportPath = "C:\temp\Passwords_$logDate.csv"

# Define UPN

# Store the data from NewUsersRP.csv in the $ADUsers variable
$ADUsers = Import-Csv $ImportPath

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
            -Name "$Firstname $Lastname ($Extname)"  ` <# ($EXTname) -Name "$Firstname $Lastname (Ext-Landi)" ` #>`
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname $firstname ($Extname)" ` <# -DisplayName "$Firstname $Lastname (Ext-Landi)" ` #>`
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Company $company `
            -Country $country `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -Description $description `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # If user is created, show message
       # Write-Host "The user account $username is created." -ForegroundColor Cyan
        write-host $User.firstname $User.lastname "|" $User.username created -ForegroundColor cyan 
        $User | Add-Member -MemberType NoteProperty -Name "Random Generated Password" -Value $password -Force
        $User | Add-Member -MemberType NoteProperty -Name "test" -Value $Extname -Force
    }

    # Export
    $ADUsers | Export-Csv -Encoding UTF8 $ExportPath -NoTypeInformation
}

Read-Host -Prompt "Press Enter to exit"