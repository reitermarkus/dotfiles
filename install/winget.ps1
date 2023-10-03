# Install App-Installer
Add-AppxPackage https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

winget source update

winget install --accept-package-agreements --accept-source-agreements -e --id AutoHotkey.AutoHotkey
winget install --accept-package-agreements --accept-source-agreements -e --id TeamSpeakSystems.TeamSpeakClient
winget install --accept-package-agreements --accept-source-agreements -e --id Mumble.Mumble.Client
winget install --accept-package-agreements --accept-source-agreements -e --id Valve.Steam
