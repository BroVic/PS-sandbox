param(
    [string[]]$Attachments=@()
)

Add-Type -Path 'C:\\Program Files\\PackageManagement\\NuGet\\Packages\\MailKit.2.9.0\\lib\\net45\\MailKit.dll'
Add-Type -Path 'C:\\Program Files\\PackageManagement\\NuGet\\Packages\\MimeKit.2.9.2\\lib\\net45\\MimeKit.dll'

$SMTP = New-Object MailKit.Net.Smtp.SmtpClient
$Message = New-Object MimeKit.MimeMessage
$TextPart = [Mimekit.TextPart]::new("plain")
$TextPart.Text = "This is the body of the message."

$From = "cemchltd@gmail.com"
$To = "victorordu@outlook.com"
$Message.From.Add($From)
$Message.To.Add($To)
$Message.Subject = "Test message with multiple attachments"

if (-not $Attachments) {
    $Message.Body = $TextPart
} else {
    # Create multipart container
    $multipart = [MimeKit.Multipart]::new("mixed")
    $multipart.Add($TextPart)

    $Attachments |
        ForEach-Object {
            # Prepare attachments
            $file = Resolve-Path -Path $_
            $ext = $(Split-Path $file -Extension).TrimStart(".")
            if ("jpg" -eq $ext) {
                $mediaType = "image"
                $subType = "jpeg"
            } elseif ("pdf" -eq $ext) {
                $mediaType = "application"
                $subType = $ext
            } elseif ("txt" -eq $ext) {
                $mediaType = "text"
                $subType = "plain"
            } else {
                Write-Error "The attachment format is not supported"
                exit(1)
            }

            $attachment = [MimeKit.MimePart]::new($mediaType, $subType)
    
            $path = [System.IO.File]::OpenRead($file)
            $contentEncoding = New-Object MimeKit.ContentEncoding
            $attachment.Content = [MimeKit.MimeContent]::new($path, $contentEncoding)
            $attachment.ContentDisposition = [MimeKit.ContentDisposition]::new("attachment")
            $attachment.ContentTransferEncoding = [MimeKit.ContentEncoding]::Base64 
            
            $multipart.Add($attachment)
        }
    
    $Message.Body = $multipart
} 

$SMTP.Connect("smtp.gmail.com", 587, $false)
$SMTP.Authenticate($From, "eziama1986")

$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.Dispose()
