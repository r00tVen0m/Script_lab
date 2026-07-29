
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership

dsacls "CN=Deleted Objects,DC=astera,DC=cg" /R "ASTERA\svc_recovery"
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\svc_recovery:SDRPWOCCDCLCWSWPRPRC"


----------------------

$DomainDN = (Get-ADDomain).DistinguishedName
$ObjectDN = "CN=dominic hughes\0ADEL:b659aafb-c59b-4dde-b96c-fd27ba618271,CN=Deleted Objects,$DomainDN"
$Acl = Get-Acl "AD:\$ObjectDN"
$Identity = New-Object System.Security.Principal.SecurityIdentifier((Get-ADUser svc_recovery).SID)
$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::GenericAll,
    [System.Security.AccessControl.AccessControlType]::Allow
)
$Acl.AddAccessRule($Rule)
Set-Acl "AD:\$ObjectDN" $Acl
