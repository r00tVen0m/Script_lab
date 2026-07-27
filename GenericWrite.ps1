# Import the required module
Import-Module ActiveDirectory

# Define the accounts
$ServiceAccount = "svc_jenkins"
$TargetUser = "matthew.thomas"

# Retrieve the target user object
$UserObject = Get-ADUser -Identity $TargetUser

# Get the Distinguished Name (DN)
$UserDN = $UserObject.DistinguishedName

# Retrieve the target user's security descriptor
$ACL = Get-ADObject -Identity $UserDN -Properties ntSecurityDescriptor
$SecurityDescriptor = $ACL.ntSecurityDescriptor

# Create a new access rule granting GenericWrite to svc_jenkins
$AccountSID = (Get-ADUser -Identity $ServiceAccount).SID
$AccessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $AccountSID,
    [System.DirectoryServices.ActiveDirectoryRights]::GenericWrite,
    [System.Security.AccessControl.AccessControlType]::Allow,
    [System.Guid]::Empty,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)

# Add the access rule to the security descriptor
$SecurityDescriptor.AddAccessRule($AccessRule)

# Apply the updated security descriptor to the target user
Set-ADObject -Identity $UserDN -ntSecurityDescriptor $SecurityDescriptor

Write-Host "✅ Successfully granted GenericWrite permission to '$ServiceAccount' on '$TargetUser'." -ForegroundColor Green



#----------------------------------------------
# Verify whether svc_jenkins has GenericWrite permissions on the user "oliva"

# التحقق من الصلاحية
$TargetUser = "matthew.thomas"
$ServiceAccount = "svc_jenkins"

$UserObject = Get-ADUser -Identity $TargetUser
$UserDN = $UserObject.DistinguishedName

$ACL = Get-ADObject -Identity $UserDN -Properties ntSecurityDescriptor

# عرض صلاحيات svc_jenkins على matthew.thomas
$ACL.ntSecurityDescriptor.Access | Where-Object {
    $_.IdentityReference -like "*$ServiceAccount*"
} | Format-Table IdentityReference, ActiveDirectoryRights, AccessControlType -AutoSize
