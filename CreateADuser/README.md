# Active Directory User Creation Script

## Overview
This PowerShell script automates the process of creating Active Directory (AD) user accounts based on data from a CSV file. It assigns random passwords, configures user properties, and ensures users are added to specified organizational units (OUs).

## Features
- Imports user details from a CSV file.
- Checks for existing user accounts before creation.
- Generates a secure random password for each new user.
- Assigns user attributes such as name, email, department, and job title.
- Supports organizational unit (OU) assignment.
- Adds users to specific Active Directory groups via an additional script.
- Exports user details, including passwords, to a CSV file.

## Prerequisites
- PowerShell must be run with administrator privileges.
- The Active Directory PowerShell module must be installed.
- Ensure the CSV file is located in `C:\temp\powershellscript\csv\`.
- Active Directory must be properly configured.

## CSV File Format
The CSV file should contain the following columns:

```
username,firstname,lastname,initials,Extname,ou,email,upn,streetaddress,city,country,manager,zipcode,state,telephone,jobtitle,company,description,department,action
```
![image](https://github.com/user-attachments/assets/db3373c6-b253-4aba-ae36-b5f745164bb5)

- `username`: The SAMAccountName for the user.
- `firstname` & `lastname`: User's first and last names.
- `ou`: The organizational unit where the user will be placed.
- `email` & `upn`: User email and User Principal Name.
- `manager`: Manager's Distinguished Name (DN).
- `action`: Must be set to `create` for the script to process the user.

## Usage Instructions
### Step 1: Prepare CSV File
Place the correctly formatted CSV file in `C:\temp\powershellscript\csv\`.

### Step 3: input the keyword "create" in the action column in CSV file : 
### Step 2: Run the Script
Open PowerShell as an administrator and execute the script:

```powershell
.<script-name>.ps1
```

The script will:
1. Import user data from the CSV file.
2. Validate if users already exist in Active Directory.
3. Generate random passwords.
4. Create new users with the specified attributes.
5. Assign users to the correct Organizational Unit (OU).
6. Export user details, including passwords, to `C:\temp\powershellscript\pwd\Passwords_yyyyMMdd_HHmmffff.csv`.
7. Add users to AD groups using a secondary script.

### Step 3: Verify User Creation
After execution, confirm that the users have been created successfully:

```powershell
Get-ADUser -Filter * | Select-Object Name, SamAccountName, EmailAddress, Department
```

## Troubleshooting
- **Script not running?** Ensure PowerShell execution policy allows running scripts:
  ```powershell
  Set-ExecutionPolicy Unrestricted -Scope Process
  ```
- **Users not created?** Check the error messages; ensure the CSV data is formatted correctly.
- **Incorrect OU?** Verify the OU path provided in the CSV file.

## Notes
- The script logs all created users and their generated passwords. Store the exported password file securely.
- Modify the `Get-RandomPassword` function to adjust password complexity.
- Users who already exist in AD will not be recreated.

## can setup task scheduler > refer to the section https://github.com/GAS-inno/Powershell/blob/main/AD_PowerShell/Scheduler_Enable_Disable_ADuser_Account/README.md

## Disclaimer
This script modifies Active Directory. Use with caution and test in a controlled environment before deploying in production.


