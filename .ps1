#!/usr/bin/env pwsh

$cleanup = $FALSE
$dotfilesDir = $PSScriptRoot

try {
  If ($TRUE -or $MyInvocation.InvocationName -eq '.') {
    Write-Output 'Downloading Github Repository …'
    $cleanup = $TRUE

    $tempPath = (Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName()))
    New-Item -ItemType Directory -Path $tempPath | Out-Null

    $dotfilesDir = (Join-Path $tempPath 'dotfiles')
    $dotfilesZip = $dotfilesDir + '.zip'

    try {
      Invoke-WebRequest -Uri 'https://github.com/reitermarkus/dotfiles/archive/windows.zip' -OutFile $dotfilesZip
      Expand-Archive -Path $dotfilesZip -DestinationPath $tempPath -Force
      Move-Item -Path (Join-Path $tempPath 'dotfiles-windows') -Destination $dotfilesDir
    } finally {
      Remove-Item $dotfilesZip -Force
    }
  }
} finally {
  If ($cleanup) {
    Remove-Item $dotfilesDir -Force -Recurse
  }
}
