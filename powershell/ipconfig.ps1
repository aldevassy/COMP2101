$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}


$results = @()
foreach ($adapter in $adapters) {
    
    $description = $adapter.Description
    $index = $adapter.Index

    
    $ipAddresses = $adapter.IPAddress
    $subnetMasks = $adapter.IPSubnet

    $dnsDomain = $adapter.DNSDomain
    $dnsServers = $adapter.DNSServerSearchOrder

    
    $ipConfigurations = for ($i = 0; $i -lt $ipAddresses.Count; $i++) {
        "$($ipAddresses[$i])/$($subnetMasks[$i])"
    }

    
    $result = [PSCustomObject]@{
        Description = $description
        Index = $index
        IPAddress = $ipConfigurations -join ', '
        DNSDomain = $dnsDomain
        DNSServers = $dnsServers -join ', '
    }
    $results += $result
}


$results | Format-Table Description, Index, IPAddress, DNSDomain, DNSServers -AutoSize
