#!/usr/bin/env bash

set -euo pipefail

#
# Config
#

WIN_OUTPUT_PATH="\\\\wsl.localhost\\${1}\\tmp\\.os-theme"

#
# PowerShell payload
#

POWERSHELL_SCRIPT=$(cat <<EOF
#
# Config
#

\$outputFile = "$WIN_OUTPUT_PATH"

#
# Main
#

\$regPathWin32 = "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize"
\$valueName = "SystemUsesLightTheme"

# Win32 interop
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;

public static class NativeRegistry {
    public const int KEY_NOTIFY = 0x0010;
    public const int REG_NOTIFY_CHANGE_LAST_SET = 0x00000004;

    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern int RegOpenKeyEx(
        IntPtr hKey,
        string lpSubKey,
        int ulOptions,
        int samDesired,
        out SafeRegistryHandle phkResult
    );

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern int RegNotifyChangeKeyValue(
        SafeRegistryHandle hKey,
        bool bWatchSubtree,
        int dwNotifyFilter,
        IntPtr hEvent,
        bool fAsynchronous
    );

    public static readonly IntPtr HKEY_CURRENT_USER =
        new IntPtr(unchecked((int)0x80000001));
}
"@

# Open registry key
\$hKey = \$null
\$result = [NativeRegistry]::RegOpenKeyEx(
    [NativeRegistry]::HKEY_CURRENT_USER,
    \$regPathWin32,
    0,
    [NativeRegistry]::KEY_NOTIFY,
    [ref]\$hKey
)

if (\$result -ne 0) {
    throw "Failed to open registry key (error \$result)"
}

# Theme writer
function Apply-Theme {
    \$currentValue = (Get-ItemProperty -Path "HKCU:\\\$regPathWin32" -Name \$valueName).\$valueName
    if (\$currentValue -eq 0) {
        [Console]::WriteLine("Switching to dark theme")
        "dark" | Out-File -FilePath \$outputFile -Encoding utf8
    } else {
        [Console]::WriteLine("Switching to light theme")
        "light" | Out-File -FilePath \$outputFile -Encoding utf8
    }
}

# Apply theme on start
Apply-Theme

# Interruptible wait loop
\$event = New-Object System.Threading.AutoResetEvent(\$false)
\$running = \$true

Register-EngineEvent PowerShell.Exiting -Action {
    \$global:running = \$false
}

Write-Host "Watching Windows system theme changes..."

while (\$running) {
    [NativeRegistry]::RegNotifyChangeKeyValue(
        \$hKey,
        \$false,
        [NativeRegistry]::REG_NOTIFY_CHANGE_LAST_SET,
        \$event.SafeWaitHandle.DangerousGetHandle(),
        \$true
    ) | Out-Null

    if (\$event.WaitOne(1000)) {
        Apply-Theme
    }
}
EOF
)

#
# Exec PowerShell (replace shell for proper signal handling)
#

exec /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
  -NoProfile \
  -ExecutionPolicy Bypass \
  -Command "$POWERSHELL_SCRIPT"
