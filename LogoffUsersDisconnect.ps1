#Script that disconnects inactive users on system carrying more than 48 h.
#Created By: Isaac Iborra (iiborra@externos.itnow.es)

$usersAll = quser
$usersDisc = quser | select-string "Disc" | select-string -notmatch "services"
$now = (get-date).tostring('MM_dd_yyyy')
$results = @()
$results += $usersAll
$currentfolder = Split-Path -parent $PSCommandPath 
$rutaDelArchivo = $currentfolder + "\Logs\MonitDisconnected_"+$now+".txt"
Get-ChildItem -Path $currentfolder"\Logs" -Recurse | Where-Object CreationTime -LT (Get-Date).AddDays(-30) | Remove-Item 

if ($usersDisc){
	$usersDisc | % {
		$split = ($_.tostring() -split ' +')
		$user = $split[1]
		$date = $split[4]
		if ($date.indexof("+") -ne -1){
			$days = $date.split("+")
			if ($days -contains "1" -or $days -contains "2") {
				$comments = "user: $user dated $date is Disconnect to $days Days." 
				Write-Host $comments
				$results += $comments
			}else{
				$comments = "Proceed to disconnecting the user: $user dated $date for $days to Disconnect"
				Write-Host $comments
				$results += $comments
				logoff ($_.tostring() -split ' +')[2]
			}
		} else {
			$comments = "The user $user idle time to disconnect is $date"
			Write-Host $comments
			$results += $comments
		}
	}

}else{
	$comments = "There are no inactive users in the system"
	Write-Host $comments
	$results += $comments
}

$results| Out-File -FilePath $rutaDelArchivo
