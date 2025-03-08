import os
import shutil

# Define the source folder containing the PowerShell scripts
source_folder = "./test"

# Define the categories and their corresponding commands
categories = {
    "AD_user_group": ["Get-ADGroupMember", "Get-ADUser"],
    "AAD_user_group": ["Get-AzureADUser", "Get-AzureADUserRegisteredDevice", "Get-MgGroup", "Get-MgGroupMember", "Get-MgUser"],
    "Exchange_Online_Mailbox": ["Get-Mailbox", "Get-RemoteMailbox"],
}

# Create category folders if they don't exist
for category in categories.keys():
    category_folder = os.path.join(source_folder, category)
    os.makedirs(category_folder, exist_ok=True)

# Move scripts to the appropriate category folder based on content
for file in os.listdir(source_folder):
    file_path = os.path.join(source_folder, file)
    if os.path.isfile(file_path) and file.endswith('.ps1'):  # Check for PowerShell scripts
        moved = False
        try:
            with open(file_path, 'r', encoding='utf-8') as script_file:
                content = script_file.read()
                for category, commands in categories.items():
                    if any(command in content for command in commands):
                        shutil.move(file_path, os.path.join(source_folder, category, file))
                        print(f"Moved: {file} to {category}")
                        moved = True
                        break
        except Exception as e:
            print(f"Error reading {file}: {e}")

        if not moved:
            print(f"No category found for: {file}")

print("\nScript organization completed.")