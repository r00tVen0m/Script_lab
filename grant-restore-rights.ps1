$DomainDN = (Get-ADDomain).DistinguishedName
$Acl = Get-Acl "AD:\$DomainDN"

$RulesToRemove = $Acl.Access | Where-Object { $_.IdentityReference -like "*svc_recovery*" }

foreach ($rule in $RulesToRemove) {
    $Acl.RemoveAccessRule($rule) | Out-Null
}

Set-Acl "AD:\$DomainDN" $Acl

dsacls "CN=Deleted Objects,DC=astera,DC=cg" /R "ASTERA\svc_recovery"

dsacls "OU=Users,OU=CORP,DC=astera,DC=cg" /R "ASTERA\svc_recovery"


dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\svc_recovery:LCRPWPCCDCRCLO" /I:T

# 1. تفعيل رؤية الكائنات المحذوفة في جلسة الـ PowerShell الحالية
Set-ADDefaultDomainPartition -ShowDeletedObjects $true

# 2. تعريف المتغيرات والمسار
$DomainDN = (Get-ADDomain).DistinguishedName
$DeletedObjectsDN = "CN=Deleted Objects,$DomainDN"

# 3. جلب الـ ACL للحاوية (سنجد أنه يعمل الآن بنجاح)
$Acl = Get-Acl "AD:\$DeletedObjectsDN"

# 4. إنشاء القاعدة ومنح الصلاحيات لحساب svc_recovery
$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    [System.Security.Principal.NTAccount]"svc_recovery",
    [System.Security.DirectoryServices.ActiveDirectoryRights]::GenericAll,
    [System.Security.AccessControl.AccessControlType]::Allow,
    [System.Security.DirectoryServices.ActiveDirectorySecurityInheritance]::All
)

# 5. تطبيق التعديلات
$Acl.AddAccessRule($Rule)
Set-Acl "AD:\$DeletedObjectsDN" $Acl
