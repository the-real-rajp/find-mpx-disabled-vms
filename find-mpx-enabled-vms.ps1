<#
.DESCRIPTION
    This script runs powershell commands that find MPX settings on all VMs in one vCenter.
    You will be given a username and password prompt. This script doesn't store any usernames or passwords.
    User must have read access to vCenter.
    
    This script is based on VMware KB 76799 (https://kb.vmware.com/s/article/76799)
.PARAMETER
    There are no paramenter to run this script
.NOTES
    Author: Raj Patel <raj@rajpatel.co>
    Revision: Feb 22, 2023
    Changelog: none
#>


# Check if PowerCLI is loaded
if (!(Get-Module -Name VMware.VimAutomation.Core)) {
  Write-Host "Loading PowerCLI module..."
  Import-Module VMware.VimAutomation.Core
}

# Connect to vCenter
Connect-VIServer -Server vcenter.home.lab -User 'administrator@vsphere.local' -Password 'EUc7;egEFbw,Z7zf'

# Get a list of all VMs
$VMs = Get-VM

# Create a new CSV file
$CSVFile = "VM_MPX_Enabled.csv"
Remove-Item $CSVFile -ErrorAction SilentlyContinue

# Create an empty array to store the VMs with MPX enabled
$MPXEnabledVMs = @()

# Loop through each VM and check if MPX is enabled
foreach ($VM in $VMs) {
  $VMView = Get-View -Id $VM.Id
  $Config = $VMView.Config
  if ($Config.Firmware -eq "efi") {
    $MPXEnabled = $True
  } else {
    $MPXEnabled = $False
  }
  $VMInfo = New-Object PSObject -Property @{
    "VMName" = $VM.Name
    "MPXEnabled" = $MPXEnabled
  }
  $MPXEnabledVMs += $VMInfo
  Write-Output $VMInfo
}

# Export the list of MPX enabled VMs to a CSV file
$MPXEnabledVMs | Export-Csv -Path $CSVFile -NoTypeInformation

# Disconnect from vCenter
Disconnect-VIServer -Confirm:$False