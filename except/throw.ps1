[int]$num = Read-Host "Enter a number less than 5"

if ($num -ge 5) {
    throw "You entered a number that is not less than 5"
}
else {
    Write-Host "You entered $num"
}
