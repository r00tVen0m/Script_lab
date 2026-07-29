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
