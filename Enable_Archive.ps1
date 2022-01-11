#enable remotemailbox
Enable-RemoteMailbox -Identity "$user" -Archive
Set-ADUser -Identity $user -Replace @{msexchArchiveStatus="1"}


#check if it is enable
Get-remotemailbox $user |  Format-List Name,RecipientTypeDetails,PrimarySmtpAddress,*Archive*

#check mailboxStatistics
Get-MailboxFolderStatistics -Identity $user -FolderScope RecoverableItems -IncludeAnalysis