Param ([Parameter (Mandatory=$false)][switch]$Disks,
	   [Parameter (Mandatory=$false)][switch]$System,
       [Parameter (Mandatory=$false)][switch]$Network)


if($Disks) {
    get-mydisks
}


if($System) {
    get-cpuinfo
    get-OS
    get-ram
    get-Video
}

if($Network) {
    get-net
}



if((!$System) -and (!$Disks) -and (!$Network)) {
    get-System
    get-cpuinfo
    get-OS
    get-ram
    get-mydisks
    get-net
    get-Video
}