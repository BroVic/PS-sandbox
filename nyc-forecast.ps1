# Script to get weather forecast
$City = "New York"
$weather = Invoke-WebRequest -Uri "http://wttr.in/$City"

$text = $weather.ParsedHtml.body.outerText

$text

$text | Out-GridView