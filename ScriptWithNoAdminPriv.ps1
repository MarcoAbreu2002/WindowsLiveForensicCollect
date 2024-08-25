# Define the output directory
$outputDir = Read-Host "Destination (D:\SystemInfo):"

# Create the directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# Function to save output to file
function Save-OutputToFile {
    param (
        [string]$fileName,
        [object]$content
    )
    $filePath = Join-Path -Path $outputDir -ChildPath $fileName
    $content | Out-File -FilePath $filePath -Encoding utf8
}

# Function to collect Volatile Fragment Windows
function Collect-VolatileFragmentWindows {
    $volatileFragmentWindows = Get-Process | Format-Table -AutoSize
    Save-OutputToFile -fileName "VolatileFragmentWindows.txt" -content $volatileFragmentWindows
}

# Function to collect Routing table, ARP cache, and Kernel statistics
function Collect-RoutingARPKernel {
    $routeTable = route print
    Save-OutputToFile -fileName "RoutingTable.txt" -content $routeTable

    $arpCache = arp -a
    Save-OutputToFile -fileName "ARPCache.txt" -content $arpCache

    $kernelStats = netstat -s
    Save-OutputToFile -fileName "KernelStatistics.txt" -content $kernelStats
}

# Function to collect DNS cache
function Collect-DNSCache {
    $dnsCache = ipconfig /displaydns
    Save-OutputToFile -fileName "DNSCache.txt" -content $dnsCache
}

# Function to collect list of running processes
function Collect-RunningProcesses {
    $runningProcesses = Tasklist /v
    Save-OutputToFile -fileName "RunningProcesses.txt" -content $runningProcesses
}

# Function to collect active network connections
function Collect-ActiveNetworkConnections {
    $netConnections = netstat -an
    Save-OutputToFile -fileName "ActiveNetworkConnections.txt" -content $netConnections
}

# Function to collect programs and services using the network
function Collect-ProgramsUsingNetwork {
    $netPrograms = Get-NetTCPConnection
    $netPrograms = $netPrograms | ForEach-Object {
        $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            LocalAddress  = $_.LocalAddress
            LocalPort     = $_.LocalPort
            RemoteAddress = $_.RemoteAddress
            RemotePort    = $_.RemotePort
            State         = $_.State
            ProcessId     = $_.OwningProcess
            ProcessName   = if ($process) { $process.Name } else { "N/A" }
        }
    }
    Save-OutputToFile -fileName "ProgramsAndServicesUsingNetwork.txt" -content $netPrograms
}

# Function to collect open files
function Collect-OpenFiles {
    $openFiles = Get-Process | ForEach-Object { $_.Modules 2>$null } | Where-Object { $_ } | Select-Object @{Name="ProcessName";Expression={$_.Parent.ProcessName}}, @{Name="ProcessId";Expression={$_.Parent.Id}}, FileName
    Save-OutputToFile -fileName "OpenFiles.txt" -content $openFiles
}

# Function to collect network shares
function Collect-NetworkShares {
    $networkShares = net share
    Save-OutputToFile -fileName "NetworkShares.txt" -content $networkShares
}

# Function to collect open ports
function Collect-OpenPorts {
    $openPorts = netstat -an | Select-String "LISTENING"
    Save-OutputToFile -fileName "OpenPorts.txt" -content $openPorts
}

# Function to collect connected users
#function Collect-ConnectedUsers {
#    $connectedUsers = quser
#    Save-OutputToFile -fileName "ConnectedUsers.txt" -content $connectedUsers
#}

# Function to collect encrypted archives
function Collect-EncryptedArchives {
    $encryptedArchives = Get-ChildItem -Path C:\ -Recurse -Include *.zip, *.rar, *.7z, *.tar.gz, *.tar.bz2, *.gpg -ErrorAction SilentlyContinue
    Save-OutputToFile -fileName "EncryptedArchives.txt" -content $encryptedArchives
}

# Function to collect active network shares
function Collect-ActiveNetworkShares {
    $activeNetworkShares = net use
    Save-OutputToFile -fileName "ActiveNetworkShares.txt" -content $activeNetworkShares
}

# Function to collect remote accesses and network monitoring
function Collect-RemoteAccess {
    $remoteAccess = ./psloglist.exe
    Save-OutputToFile -fileName "RemoteAccesses.txt" -content $remoteAccess
}

# Function to collect system and network configuration
function Collect-SystemNetworkConfig {
    $systemConfig = Get-WmiObject -Class Win32_ComputerSystem
    Save-OutputToFile -fileName "SystemConfiguration.txt" -content $systemConfig

    $networkConfig = Get-NetIPConfiguration
    Save-OutputToFile -fileName "NetworkConfiguration.txt" -content $networkConfig
}

# Function to collect storage devices
function Collect-StorageDevices {
    $storageDevices = Get-WmiObject -Class Win32_DiskDrive
    Save-OutputToFile -fileName "StorageDevices.txt" -content $storageDevices
}

# Function to collect date and time
function Collect-DateAndTime {
    $dateAndTime = Get-Date
    Save-OutputToFile -fileName "DateAndTime.txt" -content $dateAndTime
}

# Function to collect environment variables
function Collect-EnvironmentVariables {
    $envVariables = Get-ChildItem Env:
    Save-OutputToFile -fileName "EnvironmentVariables.txt" -content $envVariables
}

# Function to collect network card information
function Collect-NetworkCardInfo {
    $networkCardInfo = ipconfig /all
    Save-OutputToFile -fileName "NetworkCardInfo.txt" -content $networkCardInfo
}

# Function to collect services
function Collect-StartedServices {
    $startedServices = net start
    Save-OutputToFile -fileName "startedServices.txt" -content $startedServices
}

# Function to collect scheduled tasks
function Collect-ScheduledTasks {
    $scheduledTasks = schtasks
    Save-OutputToFile -fileName "schedueledTasks.txt" -content $scheduledTasks
}

# Function to collect IPv6 Neighbor Cache
function Collect-IPv6NeighborCache {
    $ipv6NeighborCache = netsh int ipv6 show neigh
    Save-OutputToFile -fileName "IPv6NeighborCache.txt" -content $ipv6NeighborCache
}

# Function to collect Wi-Fi Events
function Collect-WiFiEvents {
    $wifiEvents = netsh wlan show all
    Save-OutputToFile -fileName "WiFiEvents.txt" -content $wifiEvents
}

# Function to collect accesses in cache
function Collect-AccessesInCache {
    $accessesInCache = netstat -s
    Save-OutputToFile -fileName "AccessesInCache.txt" -content $accessesInCache
}

# Function to collect open files using handle.exe
function Collect-AccessesOpenFiles {
    $accessesOpenFiles = ./handle.exe
    Save-OutputToFile -fileName "AccessesOpenFiles.txt" -content $accessesOpenFiles
}

# Function to collect account information
function Collect-AccountInfo {
    $accountInfo = net accounts
    Save-OutputToFile -fileName "AccountInfo.txt" -content $accountInfo
}

# Function to collect shared resources
function Collect-SharedResources {
    $sharedResources = net share
    Save-OutputToFile -fileName "SharedResources.txt" -content $sharedResources
}

# Function to collect process information
function Collect-ProcessInfo {
    $processInfo = Get-WmiObject Win32_Process -Property Name,ProcessId,Priority,ThreadCount,PageFileUsage
    # Output the information
    $finalInfo = $processInfo | Select-Object Name,ProcessId,Priority,ThreadCount,PageFileUsage | Format-Table -AutoSize
    Save-OutputToFile -fileName "processInfo.txt" -content $finalInfo
}

# Function to list current connections
function Collect-CurrentConnections {
    $currentConnections = rasdial
    Save-OutputToFile -fileName "CurrentConnections.txt" -content $currentConnections
}

# Function to list Wi-Fi profiles
function Collect-WiFiProfiles {
    $wifiProfiles = netsh wlan show profiles
    Save-OutputToFile -fileName "WiFiProfiles.txt" -content $wifiProfiles
}

# Function to run all data collection functions
function Run-All {
    Collect-VolatileFragmentWindows
    Collect-RoutingARPKernel
    Collect-DNSCache
    Collect-RunningProcesses
    Collect-ActiveNetworkConnections
    Collect-ProgramsUsingNetwork
    Collect-OpenFiles
    Collect-NetworkShares
    Collect-OpenPorts
    #Collect-ConnectedUsers
    Collect-EncryptedArchives
    Collect-ActiveNetworkShares
    Collect-RemoteAccess
    Collect-SystemNetworkConfig
    Collect-StorageDevices
    Collect-DateAndTime
    Collect-EnvironmentVariables
    Collect-NetworkCardInfo
    Collect-StartedServices
    Collect-ScheduledTasks
    Collect-IPv6NeighborCache
    Collect-WiFiEvents
    Collect-AccessesInCache
    Collect-AccessesOpenFiles
    Collect-AccountInfo
    Collect-SharedResources
    Collect-ProcessInfo
    Collect-CurrentConnections
    Collect-WiFiProfiles
    Write-Output "Data collection complete. Files are saved in $outputDir."
}

# Function to display the menu
function Show-Menu {
    Write-Host "Choose an option:"
    Write-Host "1. Collect Volatile Fragment Windows"
    Write-Host "2. Collect Routing table, ARP cache, and Kernel statistics"
    Write-Host "3. Collect DNS cache"
    Write-Host "4. Collect list of running processes"
    Write-Host "5. Collect active network connections"
    Write-Host "6. Collect programs and services using the network"
    Write-Host "7. Collect open files"
    Write-Host "8. Collect network shares"
    Write-Host "9. Collect open ports"
    #Write-Host "10. Collect connected users"
    Write-Host "11. Collect encrypted archives"
    Write-Host "12. Collect active network shares"
    Write-Host "13. Collect remote accesses and network monitoring"
    Write-Host "14. Collect system and network configuration"
    Write-Host "15. Collect storage devices"
    Write-Host "16. Collect date and time"
    Write-Host "17. Collect environment variables"
    Write-Host "18. Collect network card information"
    Write-Host "19. Collect services"
    Write-Host "20. Collect scheduled tasks"
    Write-Host "21. Collect IPv6 Neighbor Cache"
    Write-Host "22. Collect Wi-Fi Events"
    Write-Host "23. Collect accesses in cache"
    Write-Host "24. Collect accesses open files"
    Write-Host "25. Collect account information"
    Write-Host "26. Collect shared resources"
    Write-Host "27. Collect process information"
    Write-Host "28. List current connections"
    Write-Host "29. List Wi-Fi profiles"
    Write-Host "30. Run all"
    Write-Host "31. Exit"

    $choice = Read-Host "Enter your choice (1-31)"
    return $choice
}

# Function to execute the selected option
function Main {
    do {
        $choice = Show-Menu
        switch ($choice) {
            1 { Collect-VolatileFragmentWindows }
            2 { Collect-RoutingARPKernel }
            3 { Collect-DNSCache }
            4 { Collect-RunningProcesses }
            5 { Collect-ActiveNetworkConnections }
            6 { Collect-ProgramsUsingNetwork }
            7 { Collect-OpenFiles }
            8 { Collect-NetworkShares }
            9 { Collect-OpenPorts }
            #10 { Collect-ConnectedUsers }
            11 { Collect-EncryptedArchives }
            12 { Collect-ActiveNetworkShares }
            13 { Collect-RemoteAccess }
            14 { Collect-SystemNetworkConfig }
            15 { Collect-StorageDevices }
            16 { Collect-DateAndTime }
            17 { Collect-EnvironmentVariables }
            18 { Collect-NetworkCardInfo }
            19 { Collect-StartedServices }
            20 { Collect-ScheduledTasks }
            21 { Collect-IPv6NeighborCache }
            22 { Collect-WiFiEvents }
            23 { Collect-AccessesInCache }
            24 { Collect-AccessesOpenFiles }
            25 { Collect-AccountInfo }
            26 { Collect-SharedResources }
            27 { Collect-ProcessInfo }
            28 { Collect-CurrentConnections }
            29 { Collect-WiFiProfiles }
            30 { Run-All }
            31 { break }
            default { Write-Host "Invalid choice, please try again." }
        }
    } while ($choice -ne 31)
}

Main

Write-Output "Data collection complete. Files are saved in $outputDir."