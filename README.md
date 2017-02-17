# vsphere-veeam-tag-notifier

## Description
When using a 'tag' based system for backing up VMs with Veeam, if you inadvertently create a new VM and not
specify a tag this can cause data loss and policy enforcement issues.  By checking hourly, nightly, etc. for
VMs with missing tags and notifying administrators you can make sure you don't forget to tag VMs and miss backups.

## Installation

Requires VMware PowerCLI to be installed on the host running the script. See: www.vmware.com/go/powercli

## Usage

Requires a vCenter Credentials file "vCenter.cred" created using the VICredentialStoreItem tool:
```
New-VICredentialStoreItem -host vcenter-host.domain.com -user username -password ****** -file
```

Schedule hourly (or less frequently) using Windows Task Scheduler or similar:
```
C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -PSConsoleFile "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\vim.psc1" "& "C:\ScriptPath\vsphere-veeam-tag-notifier.ps1" >logfile.log
```

## History

17-Feb-2017: Initial script

## Credits

Written by: Anthony Siano

## License

MIT License
