# Define the source folder containing the PowerShell scripts
$sourceFolder = "C:\Users\gasaw\Downloads\test"

# Define the categories and their corresponding commands
$categories = @{
    "AD_user_group" = @("Get-ADGroupMember", "Get-ADUser")
    "AAD_user_group" = @("Get-AzureADUser", "Get-AzureADUserRegisteredDevice", "Get-MgGroup", "Get-MgGroupMember", "Get-MgUser")
    "Exchange_Online_Mailbox" = @("Get-Mailbox", "Get-RemoteMailbox")
}

# Create category folders if they don't exist
foreach ($category in $categories.Keys) {
    $categoryFolder = Join-Path -Path $sourceFolder -ChildPath $category
    if (-not (Test-Path -Path $categoryFolder)) {
        New-Item -ItemType Directory -Path $categoryFolder | Out-Null
    }
}

# Move scripts to the appropriate category folder based on content
Get-ChildItem -Path $sourceFolder -Filter *.ps1 | ForEach-Object {
    $filePath = $_.FullName
    $moved = $false

    try {
        $content = Get-Content -Path $filePath -Raw
        foreach ($category in $categories.Keys) {
            if ($categories[$category] | Where-Object { $content -match $_ }) {
                $destinationPath = Join-Path -Path $sourceFolder -ChildPath $category
                Move-Item -Path $filePath -Destination $destinationPath
                Write-Host "Moved: $($_.Name) to $category"
                $moved = $true
                break
            }
        }
    } catch {
        Write-Host "Error reading $($_.Name): $_"
    }

    if (-not $moved) {
        Write-Host "No category found for: $($_.Name)"
    }
}

Write-Host "`nScript organization completed."