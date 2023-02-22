<#
.DESCRIPTION
    This script runs powershell commands that set MPX settings on all VMs in one vCenter to false
    You will be given a username and password prompt. This script doesn't store any usernames or passwords.
    User must have read/write access to vCenter and all VMs
    
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
  $CSVFile = "VM_MPX_Set_True.csv"
  Remove-Item $CSVFile -ErrorAction SilentlyContinue
  
  # Create an empty array to store the VMs with MPX enabled
  $MPXDisabledVMs = @()
  
  # Loop through each VM
  foreach ($vm in $vms) {
      # Check if the MPX feature is disabled
      if (!(Get-VMHardware -VM $vm -ErrorAction SilentlyContinue | Where-Object {$_.DeviceInfo.Label -eq 'MPX'} | Select-Object -ExpandProperty Enabled)) {
          # Dsiable MPX on the VM
          Set-VMHardware -VM $vm -Version v11 -MPXEnabled $false
  
          # Add the VM to the array of VMs with MPX enabled
          $MPXDisabledVMs += $vm
      }
  }
  
  # Export the list of VMs with MPX enabled to a CSV file
  $MPXDisabledVMs | Select-Object Name, @{Name='MPXEnabled'; Expression={'True'}} | Export-Csv -Path $CSVFile -NoTypeInformation
  
  # Disconnect from vCenter
  Disconnect-VIServer -Confirm:$false