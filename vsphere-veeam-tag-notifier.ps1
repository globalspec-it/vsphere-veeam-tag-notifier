<#
.SYNOPSIS
  Veeam missing VM tags notification system

.DESCRIPTION
  When using a 'tag' based system for backing up VMs with Veeam, if you inadvertently create a new VM and not
  specify a tag this can cause data loss and policy enforcement issues.  By checking hourly, nightly, etc. for
  VMs with missing tags and notifying administrators you can make sure you don't forget to tag VMs and miss backups.

.PREREQUISITES
  Requires VMware PowerCLI to be installed on the host running the script. See: www.vmware.com/go/powercli

.PARAMETERS
  Requires a vCenter Credentials file "vCenter.cred" created using the VICredentialStoreItem tool.
  (eg. New-VICredentialStoreItem -host vcenter-host.domain.com -user username -password ****** -file)

.INPUTS
  See "Declarations" section to configure email options.

.LIMITATIONS
  - If there are VMs you don't want to backup, you still need to create a new tag that is not part of a backup job
    to supress the script action.
  - There is currently no support for handling anything other than "a tag exists on a VM" vs. "a tag used for backups
    exists on a VM" therefore if tags for other functionality is also used with your VMs this script will need to be
    modified to look for specific tags.

.USAGE
   Schedule hourly (or less frequently) using Windows Task Scheduler or similar.
   eg. C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -PSConsoleFile "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\vim.psc1" "& "C:\ScriptPath\vsphere-veeam-tag-notifier.ps1" >logfile.log

.NOTES
    Version:        1.0
    Author:         Anthony Siano
    Creation Date:  17-FEB-2017
    Purpose/Change: Initial script development
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$vCenterHost = "vcenter-hostname.domain.com"
$creds = Get-VICredentialStoreItem -file "vCenter.cred"
$emailFrom = "alert@domain.com"
$emailTo = "alert@domain.com"
$emailSubject = "[WARNING] New VM(s) without Backup Tags Found!"
$smtpServer = "smtp.domain.com"

#-----------------------------------------------------------[Execution]------------------------------------------------------------
Add-PSSnapIn VMware.VimAutomation.Core
Connect-VIServer -Server $vCenterHostname -User $creds.User -Password $creds.Password
$listofVMs = get-vm | ?{ (get-tagassignment $_) -eq $null}

$email = @{
  From = $emailFrom
  To = $emailTo
  Subject = $emailSubject
  SMTPServer = $smtpServer
  Body = "These VMs were discovered without tags. They will not be backed up until a tag is assigned!`n`n" +
  $listofVMs + "`n`nNOTE: You must use specify a tag even if you do not intend to backup a VM"
}

if($listofVMs){
	Write-Host "Results found, email sent."
	send-mailmessage @email
}
 	else
{
	Write-Host "No results, exiting without sending email."
}

Disconnect-VIServer -Force -Confirm:$false
