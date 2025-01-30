param
(
    $City = (Read-Host -Prompt "Enter a city: ")
)

$weather = Invoke-WebRequest -Uri "http://wttr.in/$City"

$text = $weather.ParsedHtml.body.outerText

$text

$text | Out-GridView