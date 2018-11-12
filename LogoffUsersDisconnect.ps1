#Script that disconnects inactive users on system carrying more than 48 h.
#Created By: Isaac Iborra (isaac.iborra@gmail.com)

$usersDisc = quser | select-string "Disc" | select-string -notmatch "services"
$today = (get-date).tostring('MM/dd/yyyy')
$yesterday = (get-date).addDays(-1).tostring('MM/dd/yyyy')

if ($usersDisc){
	$usersDisc | % {
		$split = ($_.tostring() -split ' +')
		$user = $split[1]
		$date = $split[5]
     
		if ($today -eq $date){
			Write-Host "User: $user is inactive today: $date"			
		}elseif ($yesterday -eq $date){
            		write-host "User: $user is inactive since yesterday: $date"
		}else{
		    Write-Host "We proceed to disconnecting the user: $user dated $date by being inactive for more than 48 h"
		    logoff ($_.tostring() -split ' +')[2]
        	}
	}
}else{
	Write-Host "There are no inactive users in the system"
}
