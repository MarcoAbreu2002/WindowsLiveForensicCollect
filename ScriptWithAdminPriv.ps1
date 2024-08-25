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

# Functions to collect data
function Collect-VolatileFragmentWindows {
    $volatileFragmentWindows = Get-Process | Format-Table -AutoSize
    Save-OutputToFile -fileName "VolatileFragmentWindows.txt" -content $volatileFragmentWindows
}

function Collect-RoutingTable {
    $routeTable = route print
    Save-OutputToFile -fileName "RoutingTable.txt" -content $routeTable
}

function Collect-ARPCache {
    $arpCache = arp -a
    Save-OutputToFile -fileName "ARPCache.txt" -content $arpCache
}

function Collect-KernelStatistics {
    $kernelStats = netstat -s
    Save-OutputToFile -fileName "KernelStatistics.txt" -content $kernelStats
}

function Collect-DNSCache {
    $dnsCache = ipconfig /displaydns
    Save-OutputToFile -fileName "DNSCache.txt" -content $dnsCache
}

function Collect-RunningProcesses {
    $runningProcesses = Tasklist /v
    Save-OutputToFile -fileName "RunningProcesses.txt" -content $runningProcesses
}

function Collect-ActiveNetworkConnections {
    $netConnections = netstat -an
    Save-OutputToFile -fileName "ActiveNetworkConnections.txt" -content $netConnections
}

function Collect-ProgramsUsingNetwork {
    $netPrograms = Get-NetTCPConnection | Select-Object -Property @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).Name}},LocalAddress,LocalPort,RemoteAddress,RemotePort,State
    Save-OutputToFile -fileName "ProgramsAndServicesUsingNetwork.txt" -content $netPrograms
}

function Collect-OpenFiles {
    $openFiles = Openfiles /query /v
    Save-OutputToFile -fileName "OpenFiles.txt" -content $openFiles
}

function Collect-NetworkShares {
    $networkShares = Get-SmbShare
    Save-OutputToFile -fileName "NetworkShares.txt" -content $networkShares
}

function Collect-OpenPorts {
    $openPorts = netstat -an | Select-String "LISTENING"
    Save-OutputToFile -fileName "OpenPorts.txt" -content $openPorts
}

#function Collect-ConnectedUsers {
#    $connectedUsers = quser
#    Save-OutputToFile -fileName "ConnectedUsers.txt" -content $connectedUsers
#}

function Collect-EncryptedArchives {
    $encryptedArchives = Get-ChildItem -Path C:\ -Recurse -Include *.zip, *.rar, *.7z, *.tar.gz, *.tar.bz2, *.gpg -ErrorAction SilentlyContinue
    Save-OutputToFile -fileName "EncryptedArchives.txt" -content $encryptedArchives
}

function Collect-ActiveNetworkShares {
    $activeNetworkShares = net use
    Save-OutputToFile -fileName "ActiveNetworkShares.txt" -content $activeNetworkShares
}

function Collect-RemoteAccess {
    $remoteAccess = Get-EventLog -LogName Security | Where-Object { $_.InstanceId -eq 4624 } | Select-Object TimeGenerated, @{Name="User";Expression={$_.ReplacementStrings[5]}}
    Save-OutputToFile -fileName "RemoteAccesses.txt" -content $remoteAccess
}

function Collect-SystemConfiguration {
    $systemConfig = Get-WmiObject -Class Win32_ComputerSystem
    Save-OutputToFile -fileName "SystemConfiguration.txt" -content $systemConfig
}

function Collect-NetworkConfiguration {
    $networkConfig = Get-NetIPConfiguration
    Save-OutputToFile -fileName "NetworkConfiguration.txt" -content $networkConfig
}

function Collect-StorageDevices {
    $storageDevices = Get-WmiObject -Class Win32_DiskDrive
    Save-OutputToFile -fileName "StorageDevices.txt" -content $storageDevices
}

function Collect-DateAndTime {
    $dateAndTime = Get-Date
    Save-OutputToFile -fileName "DateAndTime.txt" -content $dateAndTime
}

function Collect-EnvironmentVariables {
    $envVariables = Get-ChildItem Env:
    Save-OutputToFile -fileName "EnvironmentVariables.txt" -content $envVariables
}

#function Collect-ClipboardContents {
#    Add-Type -AssemblyName System.Windows.Forms
#    $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()
#    Save-OutputToFile -fileName "Clipboard.txt" -content $clipboardContent
#}

function Collect-NetworkCardInfo {
    $networkCardInfo = ipconfig /all
    Save-OutputToFile -fileName "NetworkCardInfo.txt" -content $networkCardInfo
}

function Collect-StartedServices {
    $startedServices = net start
    Save-OutputToFile -fileName "startedServices.txt" -content $startedServices
}

function Collect-ScheduledTasks {
    $scheduledTasks = schtasks
    Save-OutputToFile -fileName "scheduledTasks.txt" -content $scheduledTasks
}

function Collect-IPv6NeighborCache {
    $ipv6NeighborCache = netsh int ipv6 show neigh
    Save-OutputToFile -fileName "IPv6NeighborCache.txt" -content $ipv6NeighborCache
}

function Collect-WiFiEvents {
    $wifiEvents = netsh wlan show all
    Save-OutputToFile -fileName "WiFiEvents.txt" -content $wifiEvents
}

function Collect-ProgramsUsingNetworkDetails {
    $programsUsingNetwork = netstat -ab
    Save-OutputToFile -fileName "ProgramsUsingNetwork.txt" -content $programsUsingNetwork
}

function Collect-AccessesInCache {
    $accessesInCache = netstat -s
    Save-OutputToFile -fileName "AccessesInCache.txt" -content $accessesInCache
}

function Collect-AccessesOpenFiles {
    $accessesOpenFiles = net file
    Save-OutputToFile -fileName "AccessesOpenFiles.txt" -content $accessesOpenFiles
}

function Collect-AccountInfo {
    $accountInfo = net accounts
    Save-OutputToFile -fileName "AccountInfo.txt" -content $accountInfo
}

function Collect-SharedResources {
    $sharedResources = net share
    Save-OutputToFile -fileName "SharedResources.txt" -content $sharedResources
}

function Collect-ProcessInfo {
    $processInfo = Get-WmiObject Win32_Process -Property Name,ProcessId,Priority,ThreadCount,PageFileUsage
    $finalInfo = $processInfo | Select-Object Name,ProcessId,Priority,ThreadCount,PageFileUsage | Format-Table -AutoSize
    Save-OutputToFile -fileName "processInfo.txt" -content $finalInfo
}

function Collect-CurrentConnections {
    $currentConnections = rasdial
    Save-OutputToFile -fileName "CurrentConnections.txt" -content $currentConnections
}

function Collect-WiFiProfiles {
    $wifiProfiles = netsh wlan show profiles
    Save-OutputToFile -fileName "WiFiProfiles.txt" -content $wifiProfiles
}

#function Collect-DNSServerQuery {
#    $dnsServerQuery = nslookup -d
#    Save-OutputToFile -fileName "DNSServerQuery.txt" -content $dnsServerQuery
#}

function Run-All {
    Collect-VolatileFragmentWindows
    Collect-RoutingTable
    Collect-ARPCache
    Collect-KernelStatistics
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
    Collect-SystemConfiguration
    Collect-NetworkConfiguration
    Collect-StorageDevices
    Collect-DateAndTime
    Collect-EnvironmentVariables
    #Collect-ClipboardContents
    Collect-NetworkCardInfo
    Collect-StartedServices
    Collect-ScheduledTasks
    Collect-IPv6NeighborCache
    Collect-WiFiEvents
    Collect-ProgramsUsingNetworkDetails
    Collect-AccessesInCache
    Collect-AccessesOpenFiles
    Collect-AccountInfo
    Collect-SharedResources
    Collect-ProcessInfo
    Collect-CurrentConnections
    Collect-WiFiProfiles
    #Collect-DNSServerQuery
}

# Menu to choose function
function Show-Menu {
    Write-Host "Select an option:"
    Write-Host "1. Collect Volatile Fragment Windows"
    Write-Host "2. Collect Routing Table"
    Write-Host "3. Collect ARP Cache"
    Write-Host "4. Collect Kernel Statistics"
    Write-Host "5. Collect DNS Cache"
    Write-Host "6. Collect Running Processes"
    Write-Host "7. Collect Active Network Connections"
    Write-Host "8. Collect Programs Using Network"
    Write-Host "9. Collect Open Files"
    Write-Host "10. Collect Network Shares"
    Write-Host "11. Collect Open Ports"
    #Write-Host "12. Collect Connected Users"
    Write-Host "13. Collect Encrypted Archives"
    Write-Host "14. Collect Active Network Shares"
    Write-Host "15. Collect Remote Access"
    Write-Host "16. Collect System Configuration"
    Write-Host "17. Collect Network Configuration"
    Write-Host "18. Collect Storage Devices"
    Write-Host "19. Collect Date and Time"
    Write-Host "20. Collect Environment Variables"
    # Write-Host "21. Collect Clipboard Contents"
    Write-Host "21. Collect Network Card Info"
    Write-Host "22. Collect Started Services"
    Write-Host "23. Collect Scheduled Tasks"
    Write-Host "24. Collect IPv6 Neighbor Cache"
    Write-Host "25. Collect Wi-Fi Events"
    Write-Host "26. Collect Programs Using Network Details"
    Write-Host "27. Collect Accesses in Cache"
    Write-Host "28. Collect Accesses Open Files"
    Write-Host "29. Collect Account Info"
    Write-Host "30. Collect Shared Resources"
    Write-Host "31. Collect Process Info"
    Write-Host "32. Collect Current Connections"
    Write-Host "33. Collect Wi-Fi Profiles"
    # Write-Host "35. Collect DNS Server Query"
    Write-Host "34. Run All"
    Write-Host "35. Exit"

    $choice = Read-Host "Enter your choice (1-35)"
    return $choice
}

function Main {
    do {
        $choice = Show-Menu
        switch ($choice) {
            1 { Collect-VolatileFragmentWindows }
            2 { Collect-RoutingTable }
            3 { Collect-ARPCache }
            4 { Collect-KernelStatistics }
            5 { Collect-DNSCache }
            6 { Collect-RunningProcesses }
            7 { Collect-ActiveNetworkConnections }
            8 { Collect-ProgramsUsingNetwork }
            9 { Collect-OpenFiles }
            10 { Collect-NetworkShares }
            11 { Collect-OpenPorts }
            #12 { Collect-ConnectedUsers }
            13 { Collect-EncryptedArchives }
            14 { Collect-ActiveNetworkShares }
            15 { Collect-RemoteAccess }
            16 { Collect-SystemConfiguration }
            17 { Collect-NetworkConfiguration }
            18 { Collect-StorageDevices }
            19 { Collect-DateAndTime }
            20 { Collect-EnvironmentVariables }
            #21 { Collect-ClipboardContents }
            21 { Collect-NetworkCardInfo }
            22 { Collect-StartedServices }
            23 { Collect-ScheduledTasks }
            24 { Collect-IPv6NeighborCache }
            25 { Collect-WiFiEvents }
            26 { Collect-ProgramsUsingNetworkDetails }
            27 { Collect-AccessesInCache }
            28 { Collect-AccessesOpenFiles }
            29 { Collect-AccountInfo }
            30 { Collect-SharedResources }
            31 { Collect-ProcessInfo }
            32 { Collect-CurrentConnections }
            33 { Collect-WiFiProfiles }
            #34 { Collect-DNSServerQuery }
            34 { Run-All }
            35 { break }
            default { Write-Host "Invalid choice, please try again." }
        }
    } while ($choice -ne 35)
}

Main

Write-Output "Data collection complete. Files are saved in $outputDir."
