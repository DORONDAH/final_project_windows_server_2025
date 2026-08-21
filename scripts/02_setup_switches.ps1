# Save Task 02 script into the scripts folder
@'
# Script: 02_setup_switches.ps1
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be executed as Administrator!"
    exit
}

$Switches = @(
    @{ Name = "vSwitch-Production"; Type = "Internal"; Notes = "Production Subnet (192.168.10.0/24)" },
    @{ Name = "vSwitch-Storage";    Type = "Private";  Notes = "Isolated Storage Subnet (10.10.20.0/24)" }
)

foreach ($Switch in $Switches) {
    $ExistingSwitch = Get-VMSwitch -Name $Switch.Name -ErrorAction SilentlyContinue
    if (-not $ExistingSwitch) {
        New-VMSwitch -Name $Switch.Name -SwitchType $Switch.Type -Notes $Switch.Notes | Out-Null
    }
}
Get-VMSwitch | Where-Object { $_.Name -in "vSwitch-Production", "vSwitch-Storage" } | Format-Table Name, SwitchType
'@ | Out-File -FilePath "scripts\02_setup_switches.ps1" -Encoding utf8