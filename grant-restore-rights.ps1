
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership

dsacls "CN=Deleted Objects,DC=astera,DC=cg" /R "ASTERA\svc_recovery"
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\svc_recovery:SDRPWOCCDCLCWSWPRPRC"
dsacls "OU=DeletedUsers,OU=CORP,DC=astera,DC=cg" /R "ASTERA\Recovery Operators"


dsacls "CN=Deleted Objects,DC=astera,DC=cg" /R "ASTERA\Recovery Operators"
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
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /G "ASTERA\Recovery Operators:SDRPWOCDCLCWSWPRPRC"


Take Ownership of the Deleted Objects Container
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /takeownership

Assign Permissions to the Deleted Objects Container
dsacls "CN=Deleted Objects,DC=astera,DC=cg" /g "Recovery_Operators:LCRP"

Assign Write Permissions to the OU or Domain to group which will have permission to restore
dsacls "DC=astera,DC=cg" /I:T /g "Recovery_Operators:WPCC"

Set restoration rights on the root of the context
dsacls "DC=astera,DC=cg" /g "Recovery_Operators:ca;Reanimate Tombstones"
