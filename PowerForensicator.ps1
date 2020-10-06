#Requires -RunAsAdministrator

$date = Get-Date -format yyyy-MM-dd_HHmm_
$transcriptLog = $outPath + "\$date" + "_PowerForensicator.log"
Start-Transcript $transcriptLog 

## Creating Directories Tree
New-Item -Path "C:\PowerForensicator\raw_files\prefetch" -ItemType Directory -Force | Out-Null
New-Item -Path "C:\PowerForensicator\raw_files\amcache" -ItemType Directory -Force | Out-Null
New-Item -Path "C:\PowerForensicator\evtx" -ItemType Directory -Force | Out-Null
New-Item -Path "C:\PowerForensicator\reg" -ItemType Directory -Force | Out-Null
New-Item -Path "C:\PowerForensicator\AV" -ItemType Directory -Force | Out-Null

Write-Host -Fore Red "
 _____                       ______                       _           _             
|  __ \                     |  ____|                     (_)         | |            
| |__) |____      _____ _ __| |__ ___  _ __ ___ _ __  ___ _  ___ __ _| |_ ___  _ __ 
|  ___/ _ \ \ /\ / / _ \ '__|  __/ _ \| '__/ _ \ '_ \/ __| |/ __/ _` | __/ _ \| '__|
| |  | (_) \ V  V /  __/ |  | | | (_) | | |  __/ | | \__ \ | (_| (_| | || (_) | |   
|_|   \___/ \_/\_/ \___|_|  |_|  \___/|_|  \___|_| |_|___/_|\___\__,_|\__\___/|_|   

"

Write-Output "=============================================="
Write-Host -Fore Yellow "Run as administrator/elevated privileges!!!"
Write-Output "=============================================="

## Global Variables
$outPath = "C:\PowerForensicator\"

## Get System info
Write-Host -Fore Green "[+] Getting System Information..."
Get-ComputerInfo -Property "WindowsBuildLabEx","WindowsInstallDateFromRegistry","WindowsProductName","OsVersion","OsArchitecture","OsHotFixes","WindowsVersion","WindowsRegisteredOrganization","WindowsRegisteredOwner","WindowsSystemRoot","BiosBIOSVersion", "BiosFirmwareType", "CsBootupState", "CsDNSHostName", "CsDomain", "CsDomainRole", "CsManufacturer", "CsModel", "CsName", "CsNetworkAdapters", "CsProcessors", "OsTotalVisibleMemorySize", "OsBootDevice", "CsUserName", "KeyboardLayout", "TimeZone" | Out-File -FilePath $outPath\SystemInfo.txt -Append -Force

## Get LocalUser Accounts
Write-Host -Fore Green "[+] Getting Local User Accounts..."	
Get-LocalUser | Select-Object Name, SID, Enabled, LastLogon | Out-File -FilePath $outPath\LocalUserAccounts.txt -Append -Force

## Get Network Info
Write-Host -Fore Green "[+] Getting Networking Information..."
cmd /c c:\windows\system32\ipconfig /all > $outPath\Ipconfig.txt 	
cmd /c c:\windows\system32\netstat.exe -anob >> $outPath\Netstats.txt
cmd /c c:\windows\system32\netstat.exe -r > $outPath\RouteTable.txt
cmd /c c:\windows\system32\ipconfig /displaydns > $outPath\Dnscache.txt
cmd /c c:\windows\system32\arp.exe -a > $outPath\Arpdata.txt

## Get Process Info
Write-Host -Fore Green "[+] Getting Process Information..."
Get-CimInstance -ClassName Win32_Process | Select-Object -Property ProcessName, ProcessId, ParentProcessId, Handles, Path, Status, CreationDate, Priority, Owner, CommandLine, ExecutablePath | Export-Csv -Path $outPath\ProcessInfo.csv -NoTypeInformation -Force

## Get Services Info
Write-Host -Fore Green "[+] Getting Services Information..."
Get-CimInstance -ClassName Win32_Service | Select-Object -Property ProcessId,StartName,State,Name,DispalyName,PathName,StartMode | Export-Csv -Path $outPath\ServicesInfo.csv -NoTypeInformation -Force

## Copying EVTX Files
$evtx = "C:\Windows\System32\Winevt\Logs\"
if (Test-Path $evtx) {
	Write-Host -Fore Green "[+] Getting EVTX Files..."	
	Copy-Item $evtx* $outPath\evtx -Recurse -Force
} else{
    Write-Host -Fore Red "[-] Unable to Get EVTX files..."
}

## Copying Reg Files
$reg = "C:\Windows\System32\Config"
if (Test-Path $reg) {
	Write-Host -Fore Green "[+] Getting Registry Files..."	
    Copy-Item $reg\SOFTWARE -force $outPath\reg -recurse -Force
    Copy-Item $reg\SAM $outPath\reg -recurse -Force
    Copy-Item $reg\SYSTEM $outPath\reg -recurse -Force
    Copy-Item $reg\SECURITY $outPath\reg -recurse -Force
} else{
    Write-Host -Fore Red "[-] Unable to Get Registry files..."
}


## Copying Prefetch Files
$prefetch = "C:\Windows\Prefetch\*.pf"
if (Test-Path $prefetch) {
	Write-Host -Fore Green "[+] Getting Prefetch Files..."	
	Copy-Item $prefetch $outPath\raw_files\prefetch -recurse -Force
} else{
    Write-Host -Fore Red "[-] Unable to Get Prefetch files..."
}

## Copying Amcache.hve Files
$amcache =  "C:\Windows\Appcompat\Programs\Amcache.*"
if (Test-Path $Amcache){
    Write-Host -Fore Green "[+] Getting Amcache Files..."	
    Copy-Item $amcache $outPath\raw_files\amcache -recurse -Force
} else{
    Write-Host -Fore Red "[-] Unable to Get Amcache files..."
}

## Checking for Trend Micro Apex One Logs
$apex_quarantine = "C:\Program Files (x86)\Trend Micro\OfficeScan Client\Suspect\"
$apex_logs = "C:\Program Files (x86)\Trend Micro\OfficeScan Client\Log\"
if ((Test-Path $apex_quarantine) -And  (Test-Path $apex_logs)) {
    Write-Host -Fore Green "[+] Getting Trend Micro Apex One Logs..."
    Copy-Item $apex_quarantine\*.* $outPath\AV -recurse -Force
    Copy-Item $apex_logs\*.* $outPath\AV -recurse -Force
} else{
    Write-Host -Fore Red "[-] Not Found Trend Micro Apex One Logs..."
}

## Checking for Symantec Endpoint Protection Logs
$sep_quarantine = "C:\ProgramData\Symantec\Symantec Endpoint Protection\1*\Data\Quarantine\"
$sep_logs = "C:\ProgramData\Symantec\Symantec Endpoint Protection\1*\Data\Logs\"
if ((Test-Path $sep_quarantine) -And (Test-Path $sep_logs)) {
    Write-Host -Fore Green "[+] Getting Symantec Endpoint Protection Logs..."
    Copy-Item $sep_quarantine\*.vbn $outPath\AV -recurse -Force
    Copy-Item $sep_logs\*.log $outPath\AV -recurse -Force
} else{
    Write-Host -Fore Red "[-] Not Found Symantec Endpoint Protection Logs..."
}

## Checking for McAfee Logs
$mcafee_quarantine = "C:\Quarantine\"
$sep_logs = "C:\ProgramData\McAfee\DesktopProtection"
if ((Test-Path $mcafee_quarantine) -And (Test-Path $sep_logs)) {
    Write-Host -Fore Green "[+] Getting McAfee Logs..."
    Copy-Item $mcafee_quarantine\*.bup $outPath\AV -recurse -Force
    Copy-Item $sep_logs\*.txt $outPath\AV -recurse -Force
} else{
    Write-Host -Fore Red "[-] Not Found McAfee Logs..."
}

## Compressing Folder
Write-Host -Fore Green "[+] Compressing Folder..."
Compress-Archive -Path $outPath\* -DestinationPath C:\PowerForensicator.zip -CompressionLevel Optimal -Force