ForEach($appId in
  "Microsoft.3DBuilder",          # 3D Builder
  "Microsoft.BingFinance",        # Bing Finance
  "Microsoft.BingNews",           # Bing News
  "Microsoft.BingSports",         # Bing Sports
  "Microsoft.BingWeather",        # Bing Weather
  "king.com.CandyCrushSodaSaga",  # Candy Crush Soda Saga
  "*.Facebook",                   # Facebook
  "Microsoft.MicrosoftOfficeHub", # Get Office and “Get Office365” Notifications
  "Microsoft.GetStarted",         # Get Started
  "Microsoft.GetHelp",            # Get Help
  "Microsoft.WindowsMaps",        # Maps
  "Microsoft.Messaging",          # Messaging
  "Microsoft.Office.OneNote",     # OneNote
  "Microsoft.SkypeApp",           # Skype
  "*.SlingTV",                    # SlingTV
  "Microsoft.Office.Sway",        # Sway
  "*.Twitter",                    # Twitter
  "Microsoft.WindowsPhone",       # Windows Phone Companion
  "Microsoft.ZuneMusic",          # Zune Music (Groove)
  "Microsoft.ZuneVideo"           # Zune Video
) {
  Get-AppxPackage "$appId" -AllUsers | Remove-AppxPackage
  Get-AppXProvisionedPackage -Online | Where DisplayNam -like "$appId" | Remove-AppxProvisionedPackage -Online
}

# Uninstall Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

# Prevent "Suggested Applications" from returning
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1
