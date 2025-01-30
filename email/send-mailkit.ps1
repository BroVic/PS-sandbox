function Send-MailkitMessage {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    param (
        [Parameter(Position = 0, Mandatory = $true)][string]$To,
        [Parameter(Position = 1, Mandatory = $true)][string]$Subject,
        [Parameter(Position = 2, Mandatory = $true)][string]$Body,
        [Parameter(Position = 3, Mandatory = $true)][Alias("ComputerName")][string]$SmtpServer = $PSEmailServer,
        [Parameter(Mandatory = $true)][string]$From,
        [string]$CC,
        [string]$BCC,
        [switch]$BodyAsHtml, $Credential,
        [Int32]$Port = 25
    )
    Process {
        $SMTP = New-Object MailKit.Net.Smtp.SmtpClient
        $Message = New-Object MimeKit.MimeMessage

        if ($BodyAsHtml) {
            $textType = "html"
        } else {
            $textType = "plain"
        }
        
        $TextPart = [MimeKit.TextPart]::new($textType)

        $TextPart.Text = $Body

        $Message.From.Add($From)
        $Message.To.Add($To)

        if ($CC) {
            $Message.CC.Add($CC)
        }

        if ($BCC) {
            $Message.Bcc.Add($BCC)
        }

        $Message.Subject = $Subject
        $Message.Body = $TextPart

        $SMTP.Connect($SmtpServer, $Port, $false)

        if ($credential) {
            $SMTP.Authenticate($Credential.UserName, $Credential.GetNetworkCredential().Password)
        }

        if ($PSCmdlet.ShouldProcess("Send the email message via Mailkit.")) {
            $SMTP.Send($Message)
        }

        $SMTP.Disconnect($true)
        $SMTP.Dispose()
    }
}