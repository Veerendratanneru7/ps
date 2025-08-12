# ---------------------------
# CONFIGURATION
# ---------------------------

$remoteComputer = "lwukwvpi386.opd.ads.uk.rsa-ins.com"
$remoteUsername = "DOMAIN\YourUsername"
$remotePassword = "YourPassword"

# ---------------------------
# SETUP CREDENTIALS
# ---------------------------

$securePass = ConvertTo-SecureString $remotePassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($remoteUsername, $securePass)

# ---------------------------
# START REMOTE SESSION
# ---------------------------

$s = New-PSSession -ComputerName $remoteComputer -Credential $cred

Invoke-Command -Session $s -ScriptBlock {
    $sharePath = "\\lwukwipi47\share$"

    try {
        # Test access by listing contents
        if (Test-Path $sharePath) {
            Write-Output " Share is reachable: $sharePath"
            Get-ChildItem $sharePath | ForEach-Object { Write-Output $_.Name }
        } else {
            Write-Error " Share path does not exist or is not reachable: $sharePath"
        }
    } catch {
        Write-Error " Failed to access share: $_"
    }
}

# ---------------------------
# CLEAN UP
# ---------------------------

Remove-PSSession $s
