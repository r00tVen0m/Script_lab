# Import the required module
# استيراد الوحدة
Import-Module ActiveDirectory

# تعريف المتغيرات (باستخدام الأسماء الصحيحة من Domain الخاص بك)
$ServiceAccount = "svc_jenkins"
$TargetUser = "matthew.thomas"

Write-Host "🚀 بدء منح صلاحية GenericWrite..." -ForegroundColor Cyan

# الحصول على كائنات المستخدمين
$UserObject = Get-ADUser -Identity $TargetUser
$ServiceObject = Get-ADUser -Identity $ServiceAccount

# الحصول على Distinguished Name
$UserDN = $UserObject.DistinguishedName
Write-Host "📌 المستهدف: $UserDN" -ForegroundColor Yellow

# الحصول على Security Descriptor الحالي
$ACL = Get-ADObject -Identity $UserDN -Properties ntSecurityDescriptor
$SecurityDescriptor = $ACL.ntSecurityDescriptor

# إنشاء قاعدة صلاحية جديدة
$AccountSID = $ServiceObject.SID
$AccessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $AccountSID,
    [System.DirectoryServices.ActiveDirectoryRights]::GenericWrite,
    [System.Security.AccessControl.AccessControlType]::Allow,
    [System.Guid]::Empty,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)

# إضافة القاعدة إلى Security Descriptor
$SecurityDescriptor.AddAccessRule($AccessRule)

# ✅ تطبيق التغييرات (بالطريقة الصحيحة)
Set-ADObject -Identity $UserDN -Replace @{ntSecurityDescriptor = $SecurityDescriptor}

Write-Host "✅ تم منح صلاحية GenericWrite لـ $ServiceAccount على $TargetUser" -ForegroundColor Green



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
