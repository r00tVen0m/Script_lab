# ==========================================
# Clean Windows History
# ==========================================

Write-Host "[*] Clearing Jump Lists..."


try {
    Remove-Item (Get-PSReadLineOption).HistorySavePath -Force -ErrorAction SilentlyContinue
} catch {}

Clear-History -ErrorAction SilentlyContinue

Write-Host "[*] Clearing CMD history..."

doskey /reinstall

Write-Host "[*] Clearing Windows Event Logs..."

wevtutil el | ForEach-Object {
    try {
        wevtutil cl $_
    } catch {}
}

Write-Host "[*] Clearing Temp folders..."

Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[+] Cleanup completed."
