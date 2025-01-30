# My second Powershell script
$myPassphrase = 123456789
Write-Host "Hello user.`nThis computer belongs to my master.`nTo use it, you need to verify your identity"
$fname = Read-Host 'Kindly enter your first name'
$password = Read-Host 'Enter your passphrase'
if ($password -ne $myPassphrase) {
	Write-Host "You failed!`nShutting down"
	Stop-Computer
} else {
	Write-Host 'Thank you'
}