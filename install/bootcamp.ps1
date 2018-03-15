$brigadierDir = (Join-Path ([System.IO.Path]::GetTempPath()) 'brigadier')
New-Item -ItemType Directory -Path $brigadierDir -Force | Out-Null

Push-Location $brigadierDir

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri 'https://github.com/timsutton/brigadier/releases/download/0.2.4/brigadier.exe' -OutFile 'brigadier.exe'

.\brigadier --install --model=iMacPro1,1 --keep-files

Pop-Location
