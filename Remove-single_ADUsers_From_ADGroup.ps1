
#REMOVE any username from any group. prompt you to ask for next action.

    do 
        {     
            $username =read-host -Prompt 'Enter a user SamAccountName to start action:  '
   #         $groupname=read-host -prompt 'Enter the group name to remove the user: '

            
             #prompt input to disable user
             write-host " "
             $yn = Read-host -Prompt "Do you want to DISABLE $username AD y/n?" 
                 if ($yn -eq 'y')
                      {
                        #to disable user AD                         
                        get-ADuser -Identity $username | Disable-ADAccount 
                       
                              write-host "`n========================================" 
                              write-host "$username has been disabled" -ForegroundColor Yellow
                              write-host "========================================`n"

                        #check if it is removed Ext attribute 2
                         get-ADuser -Identity $username -Properties * | select name, country, extensionAttribute2, enabled |ft
                       }

                        else {  write-host "you have cancelled`n" }



               #Remove from an ADGroup member
                         
            $yn2 = Read-host -Prompt "Do you want to Remove $username from an ADGroup member y/n?" 
                     if ($yn2 -eq 'y') 
                            {

                            $groupname=read-host -prompt 'Enter the group name to remove the user: '

                            Remove-ADGroupMember -Identity $groupname -Members $username -Confirm:$False

            
                              write-host "`n========================================" 
                              write-host "$username has been removed from the $groupname group" -ForegroundColor Yellow
                              write-host "========================================`n"
                             }

                             else {   write-host "you have cancelled`n" }
                                         
            

                                            
              #prompt input to delete attribute2
                   write-host " "
                   $yn3 = Read-host -Prompt "Do you want to delete Ext-Attribute2 (SG) y/n?" 
                           
                           if ($yn3 -eq 'y')
                                      {
                                         #to clear ext attribute2                         
                                     Get-ADUser -Identity $username -Properties * | Set-ADUser -Clear 'extensionAttribute2'

                                                        #check if it is removed Ext attribute 2
                                     get-ADuser -Identity $username -Properties * | select name, country, extensionAttribute2, enabled |ft
                                       }

                                               
                                      else { write-host "you have cancelled`n" }


               #prompt input last do-while loop qns
                     $yesno = Read-Host -prompt 'Do you want another user Y/N?: '
                                                
                                     
                   
      } while($yesno -eq 'y')
   
