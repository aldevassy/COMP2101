#Loops and WMI

function hardware_description{
    write-output " System Hardware Description -----------> "
    gwmi win32_computersystem | select Name, Manufacturer, Model, TotalPhysicalMemory, Description | format-list
}

function os_information {
    write-output " OS Information -----------> "
    gwmi win32_operatingsystem | select Name, Version | format-list
}

function processor_information {
    write-output " Processor Information -----------> "
    gwmi win32_processor | select Name, NumberOfCores, CurrectClockSpeed, MaxClockSpeed,
    @{
        n = "L1CacheSize";
        e = {
            switch ($_.L1CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L1CacheSize }
            };
            $data
        }
    },
    @{
        n = "L2CacheSize";
        e = {
            switch ($_.L2CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L2CacheSize }
            };
            $data
        }
    },
    @{
        n = "L3CacheSize";
        e = {
            switch ($_.L3CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L3CacheSize }
            };
            $data
        }
    } | format-list
}

function ram_information {
    write-output " RAM Information -----------> "
    $phymem = get-CimInstance win32_PhysicalMemory | select Description, manufacturer, banklabel,     devicelocator, capacity
    $phymem | format-table

    $total = 0
	foreach ($pm in $phymem) {$total = $total + $pm.capacity}
	$total = $total / 1GB
    write-output "RAM : $total GB"
    write-output " "
}

function physical_disk_information {
    write-output " Physical Disk Information -----------> "
    $diskdrives = Get-CIMInstance CIM_diskdrive | where DeviceID -ne $null

    foreach ($disk in $diskdrives) {
        $partitions = $disk | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                new-object -typename psobject -property @{
                    Model          = $disk.Model
                    Manufacturer   = $disk.Manufacturer
                    Location       = $partition.deviceid
                    Drive          = $logicaldisk.deviceid
                    "Size(GB)"     = [string]($logicaldisk.size / 1gb -as [int]) + "gb"
                    FreeSpace      = [string]($logicaldisk.FreeSpace / 1gb -as [int]) + "gb"
                    "FreeSpace(%)" = [string]((($logicaldisk.FreeSpace / $logicaldisk.size) * 100) -as [int])                     + "%"
                } | format-table -AutoSize
            }
        }
    }
}

function network_adapter_information {
    write-output " Network Adapter Information -----------> "
    get-ciminstance win32_networkadapterconfiguration | where { $_.IPEnabled -eq $True } | 
    format-table Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder -AutoSize
}

function video_information {
    write-output " Video Information -----------> "
    get-CimInstance win32_videocontroller | select description, caption, currenthorizontalresolution,     currentverticalresolution

    $h = $obj.currenthorizontalresolution
    $v = $obj.currentverticalresolution
    $resolution = "$h x $v"
    $resolution
}


# Calling all the functions

Write-Host "System Information : "

hardware_description
os_information 
processor_information 
ram_information 
physical_disk_information 
network_adapter_information 
video_information