$Script:ScriptBlockNetDNS = {
    param (
        [string] $Server,
        [string] $IP,
        [bool] $QuickTimeout,
        [bool] $Verbose
    )
    if ($Verbose) {
        $verbosepreference = 'continue'
    }
    $ReversedIP = ($IP -split '\.')[3..0] -join '.'
    $FQDN = "$ReversedIP.$Server"
    try {
        $DnsCheck = [Net.DNS]::GetHostAddresses($fqdn)
    } catch {
        $DnsCheck = $null
    }
    if ($null -ne $DnsCheck) {
        $ServerData = [PSCustomObject] @{
            IP        = $IP
            FQDN      = $FQDN
            BlackList = $Server
            IsListed  = if ($null -eq $DNSCheck.IPAddressToString) { $false } else { $true }
            Answer    = $DnsCheck.IPAddressToString -join ', '
            TTL       = ''
        }
    } else {
        $ServerData = [PSCustomObject] @{
            IP        = $IP
            FQDN      = $FQDN
            BlackList = $Server
            IsListed  = $false
            Answer    = ""
            TTL       = ''
        }
    }

    return $ServerData
}