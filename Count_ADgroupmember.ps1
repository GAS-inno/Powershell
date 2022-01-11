#prompt input
$group=read-host -Prompt 'Enter group names to add to count'
#$groups =  Get-ADgroup -Filter * | Select-Object -Property Name| Out-GridView -PassThru -Title 'Select the Groups you want to add the users' | Select-Object -ExpandProperty Name
(Get-ADGroupMember $group |select Name).count