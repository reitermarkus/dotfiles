if (-Not (Test-Path env:ChocolateyInstall)) {
  Write-Output "Installing Chocolatey ..."
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco upgrade -y chocolatey

choco install -y 7zip
choco install -y autohotkey
choco install -y cinebench
choco install -y coretemp
choco install -y cpu-z
choco install -y crystaldiskmark
choco install -y gpu-z
choco install -y hwinfo
choco install -y msiafterburner
choco install -y opera
choco install -y origin
choco install -y prime95
choco install -y steam
choco install -y telegram
choco install -y vcredist2010
choco install -y vcredist2013
choco install -y vcredist2015
choco install -y visualstudiocode
