$DomainDN = (Get-ADDomain).DistinguishedName
$Acl = Get-Acl "AD:\$DomainDN"

$Identity = New-Object System.Security.Principal.SecurityIdentifier((Get-ADUser svc_recovery).SID)
$ReanimateGuid = New-Object Guid "45ec5156-db7e-47bb-b53f-dbeb2d03c40f"

$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ReanimateGuid
)

$Acl.AddAccessRule($Rule)
Set-Acl "AD:\$DomainDN" $Acl


$Error.Clear()
try {
    $DomainDN = (Get-ADDomain).DistinguishedName
    $Acl = Get-Acl "AD:\$DomainDN"
    $Identity = New-Object System.Security.Principal.SecurityIdentifier((Get-ADUser svc_recovery).SID)
    $ReanimateGuid = New-Object Guid "45ec5156-db7e-47bb-b53f-dbeb2d03c40f"
    $Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
        $Identity,
        [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
        [System.Security.AccessControl.AccessControlType]::Allow,
        $ReanimateGuid
    )
    $Acl.AddAccessRule($Rule)
    Set-Acl "AD:\$DomainDN" $Acl -ErrorAction Stop
    Write-Host "تم التنفيذ بدون خطأ" -ForegroundColor Green
} catch {
    Write-Host "خطأ: $_" -ForegroundColor Red
}


$Acl2 = Get-Acl "AD:\$DomainDN"
$Acl2.Access | Where-Object { $_.IdentityReference -like "*svc_recovery*" }


dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\svc_recovery:LCRPWPCCDCRCLO" /I:T
