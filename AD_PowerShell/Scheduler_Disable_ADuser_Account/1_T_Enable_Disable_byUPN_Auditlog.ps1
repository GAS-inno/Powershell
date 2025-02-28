# Get the current date
$SysDate = (Get-Date -Format "d/M/yyyy").ToString()

# Set the root path
$rootpath = "\\sgsnprprtsvr\share\"

# Define the path to the CSV file
$csvPath = (Get-ChildItem -Path "$rootpath\powershellscript\csv" -Filter '*.csv').FullName

# Import CSV files
$csvfiles = Import-Csv -Path $csvPath

# Create a log file
$logPath = "$rootpath\powershellscript\log\audit_log.txt"

# Initialize the log content
$logContent = "Audit Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"

# Process each row in the CSV file
$updatedCsv = $csvfiles | ForEach-Object {
    $n = $_.upn
    $action = $_.action
    $dateDisable = $_.dateDisable
    $dateEnable = $_.dateEnable
    $ticketNumber = $_.ticketNumber  # Assuming the column name is 'ticketNumber'

    # Skip rows that are already processed
    if ($action -eq 'done-disabled' -or $action -eq 'done-enabled') {
        Write-Host "Skipping already processed user $($_.upn)"
        return $_
    }



    if ($action -eq 'disable' -and $dateDisable -eq $SysDate -and $dateDisable -ne '' -and $action -ne '') {
        # Disable the user
        Get-ADUser -Filter "userprincipalname -eq '$n'" | Disable-ADAccount
        Write-Host "-User $($_.upn) is Disabled"
        # Log the action with ticket number
        $logContent += "Ticket $ticketNumber> Disabled user $n`r`n"
        # Update the action to "done"
        $_.action = "done-disabled"
    } elseif ($action -eq 'enable' -and $dateEnable -eq $SysDate -and $dateEnable -ne '' -and $action -ne '') {
        # Enable the user
        Get-ADUser -Filter "userprincipalname -eq '$n'" | Enable-ADAccount
        Write-Host "-User $($_.upn) is Enabled"
        # Log the action with ticket number
        $logContent += "Ticket $ticketNumber> Enabled user $n`r`n"
        # Update the action to "done"
        $_.action = "done-enabled"
    } else {
        Write-Host "No action taken on -User $($_.upn). Please review your date format and action value." -ForegroundColor Yellow
        # Log the action with ticket number
        $logContent += "Ticket $ticketNumber> No action taken on user $n (invalid date format or action value)`r`n"
    }

    # Output the updated row for further processing
    $_
}

# Save the updated CSV file
$updatedCsv | Export-Csv -Path $csvPath -NoTypeInformation

# Append log content to the log file
Add-Content -Path $logPath -Value $logContent

Write-Host "Audit log saved to $logPath"
