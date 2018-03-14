Write-Output "Installing Chocolatey ..."
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco upgrade chocolatey

choco install -y 7zip
choco install -y autohotkey
choco install -y cpu-z
choco install -y gpu-z
choco install -y msiafterburner
choco install -y opera
choco install -y steam
choco install -y telegram
choco install -y vcredist2015
choco install -y visualstudiocode
