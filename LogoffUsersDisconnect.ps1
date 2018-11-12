#Script that disconnects inactive users on system carrying more than 48 h.
#Created By: Isaac Iborra (isaac.iborra@gmail.com)


Get-ChildItem -Path "D:\scripts\Controlsesiones\Logs" -Recurse | Where-Object CreationTime -LT (Get-Date).AddDays(-30) | Remove-Item 
$usersAll = quser
$usersDisc = quser | select-string "Disc" | select-string -notmatch "services"
$today = (get-date).tostring('MM/dd/yyyy')
$now = (get-date).tostring('MM_dd_yyyy')
$yesterday = (get-date).addDays(-1).tostring('MM/dd/yyyy')
$results = @()
$results += $usersAll
$rutaDelArchivo = "D:\scripts\Controlsesiones\Logs\MonitDisconnected_"+$now+".txt"

if ($usersDisc){
	$usersDisc | % {
		$split = ($_.tostring() -split ' +')
		$user = $split[1]
		$date = $split[5]
		Write-Host "$yesterday - $today - $date"
		if ($today -eq $date){
			$comments = "User: $user is inactive today: $date"
			Write-Host $comments
			$results += $comments
			
		}elseif ($yesterday -eq $date){
			$comments = "User: $user is inactive since yesterday: $date"
            write-host $comments
			$results += $comments
        }else{
			$comments = "We proceed to disconnecting the user: $user dated $date by being inactive for more than 48 h"
            Write-Host $comments
			$results += $comments
            logoff ($_.tostring() -split ' +')[2]
        }
	}
}else{
	$comments = "There are no inactive users in the system"
	Write-Host $comments
	$results += $comments
}
Write-Host "$yesterday - $today - $date"
$results| Out-File -FilePath $rutaDelArchivo
