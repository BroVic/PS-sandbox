# https://www.pipehow.tech/invoke-webscrape/

# iwr and irm
$url = "www.google.com"

$var1 = Invoke-WebRequest $url
$var1.StatusCode
$var1.RawContent
$var1.Content
$var1.InputFields
$var1.GetType()

$var2 = Invoke-RestMethod $url
$var2.GetType() 

$var2 -eq $var1.Content

# Use with structured data i.e. API
$url = "https://jsonplaceholder.typicode.com/posts/1"
$var1 = Invoke-WebRequest $url
$var1

$var2 = Invoke-RestMethod $url
$var2
$var2 -eq $var1.RawContent  # False 'cos converted to PSCustomObject

# Browse website
$url = "http://quotes.toscrape.com"
$page = Invoke-WebRequest $url
$page
$page.Links

# confirm that there are no forms
$page.Forms
$page.InputFields


$LoginPath = $($page.Links | Where-Object outerHtml -match "Login").href
$LoginUri = "$url$LoginPath"
$Site = Invoke-WebRequest $LoginUri -SessionVariable DemoSession 
# Set login credentials
$Body = @{
    'username' = "SomeUser"
    'password' = "Somepassword"
    'csrf_token' = $Site.InputFields[0].value
}

$Site = Invoke-WebRequest -Uri $LoginUri -Method Post -WebSession $DemoSession -Body $Body -ContentType 'application/x-www-form-urlencoded' 
$Site.Links | Where-Object outerHtml -like '*logout*'

$NextUri = ($Site.Links | Where-Object outerHtml -like '*next*').href
$Site = Invoke-WebRequest -Uri "$Url$NextUri" -WebSession $DemoSession

$Site.Links | Where-Object outerHtml -like '*logout*'
$Site.Links | Where-Object outerHtml -like '*Next*'
