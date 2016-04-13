$PSEmailServer = "tobit"
$sender="helpdesk@eutech.de"
$utf8 = New-Object System.Text.utf8encoding
$colItems = Get-ChildItem "F:\Profile" | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
foreach ($i in $colItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
	[int]$size = ($subFolderItems.sum / 1024 / 1024)
	$folder=$i.Name.replace(".V2","")
	$empfaenger="$folder"+"@eutech.de"
	if($size -gt 500) {
		write-host $folder $size -foregroundcolor red
		$body="Das Windows Profil EUTECH\$folder hat das Volumen von 500 MB erreicht. `r
$size MB sind aktuell belegt.`r
Um eine schnelle Anmeldung an den Systemen zu erreichen und eine Sicherung der Daten zu garantieren, wird darum gebeten, relevante Firmendaten auf 'Q' und 'H' zu speichern.`r
Private Dateien oder Downloads bitte kontinuierlich entfernen oder auslagern.
`r
EUtech IT Abteilung`r
`r`n
Bei Fragen/Hilfe durch uns einfach auf diese Mail antworten, um ein Helpdesk Ticket zu erstellen.
`r
Dies ist eine automatische Mail, die jeden Freitag verschickt wird, bis das Problem behoben ist!"
		Send-MailMessage -From $sender -Subject "Benutzerprofil Speicherplatz" -To $empfaenger -CC systemadministration@eutech.de -Body $body -SmtpServer $psemailserver -Encoding $utf8
	}
}

