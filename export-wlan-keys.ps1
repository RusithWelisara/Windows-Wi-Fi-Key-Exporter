# Exports saved Wi-Fi profile names and Key Content (plain-text passwords).
# Run from an elevated (Administrator) prompt if keys do not appear.

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$outFile = Join-Path $here 'wlan_keys.txt'

$lines = @(netsh wlan show profile 2>&1)
if ($LASTEXITCODE -ne 0) {
    Write-Error ("netsh wlan show profile failed:`n" + ($lines -join "`n"))
}

$names = $lines | ForEach-Object {
    if ($_ -match '^\s*All User Profile\s*:\s*(.+?)\s*$') {
        $matches[1].Trim()
    }
} | Where-Object { $_ }

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('# Wi-Fi Key Content export')
[void]$sb.AppendLine("# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$sb.AppendLine('# Keep this file private. Run as Administrator if Key Content is missing.')
[void]$sb.AppendLine()

foreach ($name in $names) {
    $argName = $name.Replace('"', '\"')
    $detailLines = @(netsh wlan show profile name="$argName" key=clear 2>&1)
    $key = $null
    foreach ($line in $detailLines) {
        if ($line -match '^\s*Key Content\s*:\s*(.*)$') {
            $key = $matches[1].Trim()
            break
        }
    }
    if (-not $key) { $key = '(none — open network, missing rights, or key not stored)' }

    [void]$sb.AppendLine("SSID / profile: $name")
    [void]$sb.AppendLine("Key Content: $key")
    [void]$sb.AppendLine()
}

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Write-Host "Saved: $outFile"
