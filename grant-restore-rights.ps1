
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership

dsacls "CN=Deleted Objects,DC=astera,DC=cg" /R "ASTERA\svc_recovery"
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\svc_recovery:SDRPWOCCDCLCWSWPRPRC"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /R "ASTERA\Recovery Operators"

----------------------

dsacls "DC=astera,DC=cg" /G "ASTERA\Recovery Operators:CA;Reanimate Tombstones"
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:LCRP"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /I:T /G "ASTERA\Recovery Operators:WPCC"

Get-ADObject -Filter 'isDeleted -eq $true' -IncludeDeletedObjects


dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:CCDC;user"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:WP;user"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:RP;user"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:RC"
