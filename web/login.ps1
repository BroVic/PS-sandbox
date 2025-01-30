# https://debugandrelease.blogspot.com/2018/11/logging-into-website-with-powershell.html

$URL = 'https://www.absolutesocks.com'

Invoke-WebRequest -Uri $URL

# The login link is /login.php
$Login = '/login.php'
$Homepg = '/account.php'

$InitResponse = Invoke-WebRequest "$URL$Login" -SessionVariable TestSession

# We obtained login criteria by inspecting the network panel of Developer tools in Chrome
# $Creds = Get-Credential
$Body = @{
    'login_email' = 'victorordu@gmail.com'
    'login_pass' = $Creds.GetNetworkCredential().Password
    'authenticity_token' = 'e82d7ec91b3ed01e19245fc9222f97c85d8310e1a55d11af7e44ff73cca16615'
}

$NextResponse = Invoke-WebRequest "$URL$Login" -Method Post -Body $Body -WebSession $TestSession
$NextResponse

$Response = Invoke-WebRequest "$URL$Homepg" -WebSession $TestSession
$Response

# e82d7ec91b3ed01e19245fc9222f97c85d8310e1a55d11af7e44ff73cca16615
# e82d7ec91b3ed01e19245fc9222f97c85d8310e1a55d11af7e44ff73cca16615