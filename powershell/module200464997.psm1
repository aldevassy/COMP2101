[CmdletBinding()]
param(
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

function Get-CPUReport {
    $cpu = Get-WmiObject -Class Win32_Processor
    Write-Output "CPU: $($cpu.Name)"
}

function Get-OSReport {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    Write-Output "OS: $($os.Caption) $($os.Version)"
}

function Get-RAMReport {
    $ram = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $totalRam = [math]::Round($ram.Sum / 1MB, 2)
    Write-Output "RAM: $totalRam GB"
}

function Get-VideoReport {
    $video = Get-WmiObject -Class Win32_VideoController
    Write-Output "Video: $($video.Name)"
}

function Get-DisksReport {
    $disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disk in $disks) {
        $size = [math]::Round($disk.Size / 1GB, 2)
        $free = [math]::Round($disk.FreeSpace / 1GB, 2)
        Write-Output "Disk $($disk.DeviceID): $free GB free of $size GB"
    }
}

function Get-NetworkReport {
    $network = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    foreach ($adapter in $network) {
        Write-Output "Network Adapter $($adapter.Description):"
        Write-Output "  IP Address(es): $($adapter.IPAddress)"
        Write-Output "  MAC Address: $($adapter.MACAddress)"
    }
}

if ($System) {
    Get-CPUReport
    Get-OSReport
    Get-RAMReport
    Get-VideoReport
} elseif ($Disks) {
    Get-DisksReport
} elseif ($Network) {
    Get-NetworkReport
} else {
    Get-CPUReport
    Get-OSReport
    Get-RAMReport
    Get-VideoReport
    Get-DisksReport
    Get-NetworkReport
}
