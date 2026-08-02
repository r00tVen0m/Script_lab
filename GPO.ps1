#-----------------------CreateChild------------------------------------------------

$user = Get-ADUser -Identity "lucas.reed"
$gpoContainer = "CN=Policies,CN=System,DC=astera-dev,DC=cg"
$acl = Get-Acl -Path "AD:\$gpoContainer"
$sid = New-Object System.Security.Principal.SecurityIdentifier($user.SID)
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $sid,
    [System.DirectoryServices.ActiveDirectoryRights]::CreateChild,
    [System.Security.AccessControl.AccessControlType]::Allow,
    [Guid]"f30e3bc2-9ff0-11d1-b603-0000f80367c1",  # groupPolicyContainer objectClass GUID - 
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All
)
$acl.AddAccessRule($ace)
Set-Acl -Path "AD:\$gpoContainer" -AclObject $acl


#--------------------------------WriteProperty------------------------------------

$user = Get-ADUser -Identity "noah.hayes"
$sitePath = "CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=astera-dev,DC=cg"
$acl = Get-Acl -Path "AD:\$sitePath"
$sid = New-Object System.Security.Principal.SecurityIdentifier($user.SID)
$gpLinkGuid = [Guid]"f30e3bbe-9ff0-11d1-b603-0000f80367c1"  # gPLink property GUID 
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $sid,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $gpLinkGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)
$acl.AddAccessRule($ace)
Set-Acl -Path "AD:\$sitePath" -AclObject $acl


$targetUser = "CN=noah.hayes,OU=Users,OU=CORP-DEV,DC=astera-dev,DC=cg"
$acl = Get-Acl -Path "AD:\$targetUser"



#---------------------------------------CreateChild
(Get-Acl "AD:\CN=Policies,CN=System,DC=astera-dev,DC=cg").Access | 
    Where-Object {$_.IdentityReference -like "*lucas.reed*"}

# ------------------------- WriteProperty
(Get-Acl "AD:\CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=astera-dev,DC=cg").Access | 
    Where-Object {$_.IdentityReference -like "*noah.hayes*"}


## ------------User-Force-Change-Password------------------------------

$group = Get-ADGroup -Identity "IT SUPPORT"
$targetUser = "CN=noah.hayes,OU=Users,OU=CORP-DEV,DC=astera-dev,DC=cg"

$acl = Get-Acl -Path "AD:\$targetUser"
$sid = New-Object System.Security.Principal.SecurityIdentifier($group.SID)

# GUID Extended Right: User-Force-Change-Password 
$forceChangePasswordGuid = [Guid]"00299570-246d-11d0-a768-00aa006e0529"

$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $sid,
    [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $forceChangePasswordGuid
)

$acl.AddAccessRule($ace)
Set-Acl -Path "AD:\$targetUser" -AclObject $acl


(Get-Acl "AD:\CN=noah.hayes,OU=Users,OU=CORP-DEV,DC=astera-dev,DC=cg").Access | 
    Where-Object {$_.IdentityReference -like "*IT SUPPORT*"} |
    Select-Object IdentityReference, ActiveDirectoryRights, ObjectType
