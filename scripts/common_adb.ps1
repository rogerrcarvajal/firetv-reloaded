function Ensure-AdbConnected {
    param(
        [string]$AdbPath = "c:\xampp\htdocs\amazon-firetv\tools\platform-tools\adb.exe",
        [string]$IpFile = "c:\xampp\htdocs\amazon-firetv\firetv_ip.txt"
    )
    if (Test-Path $IpFile) {
        $ip = (Get-Content $IpFile -TotalCount 1).Trim()
        if ($ip) {
            & $AdbPath connect "${ip}:5555" | Out-Null
        }
    }
}
