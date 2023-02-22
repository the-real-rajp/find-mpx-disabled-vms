# MPX VM Settings
There are 3 scitps to find and set MPX settings on VMs in vCenters.

These scripts are based on VMware KB 76799 (https://kb.vmware.com/s/article/76799)

You will be given a username and password prompt. This scripts do not store any usernames or passwords.

# find-mpx-enabled-vms.ps1

This script runs powershell commands that find MPX settings on all VMs in one vCenter.
User must have read access to vCenter.

# set-mpx-to-false.ps1

This script runs powershell commands that set MPX settings on all VMs in one vCenter to false
User must have read/write access to vCenter.

# set-mpx-to-true.ps1

This script runs powershell commands that set MPX settings on all VMs in one vCenter to true
User must have read/write access to vCenter.

