Import-Module ActiveDirectory

# Get the MAIL computer object
$Mail = Get-ADComputer -Identity "MAIL"

# Configure Resource-Based Constrained Delegation
Set-ADComputer -Identity "FILE01" `
    -PrincipalsAllowedToDelegateToAccount $Mail

Write-Host "[+] RBCD configured successfully."

---------------------

Import-Module ActiveDirectory

$rbcd = (Get-ADComputer FILE01 -Properties msDS-AllowedToActOnBehalfOfOtherIdentity).msDS-AllowedToActOnBehalfOfOtherIdentity

$rbcd.GetAccessRules($true, $true, [System.Security.Principal.SecurityIdentifier]) |
ForEach-Object {
    [PSCustomObject]@{
        SID   = $_.IdentityReference.Value
        Name  = (New-Object System.Security.Principal.SecurityIdentifier($_.IdentityReference.Value)).
                  Translate([System.Security.Principal.NTAccount]).Value
        Rights = $_.ActiveDirectoryRights
        Type   = $_.AccessControlType
    }
}
