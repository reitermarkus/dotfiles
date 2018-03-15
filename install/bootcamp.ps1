$bootcampDir = (Join-Path ([System.IO.Path]::GetTempPath()) 'bootcamp')
New-Item -ItemType Directory -Path $bootcampDir -Force | Out-Null

Push-Location $bootcampDir

Write-Output 'Downloading BootCamp Windows Support Drivers ...'
$bootcampZip = 'bootcamp5.1.5769.zip'
Invoke-WebRequest -Uri "http://support.apple.com/downloads/DL1837/$bootcampZip" -OutFile (Join-Path $bootcampDir $bootcampZip)

Write-Output 'Unpacking BootCamp Windows Support Drivers ...'
Expand-Archive -Path $bootcampZip -DestinationPath . -Force

Write-Output 'Installing BootCamp Windows Support Drivers ...'
msiexec /i BootCamp\Drivers\Apple\BootCamp.msi /qn

Pop-Location
