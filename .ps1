#!/usr/bin/env pwsh

Set-ExecutionPolicy Bypass -Scope Process -Force

$cleanup = $FALSE
$dotfilesDir = $PSScriptRoot

try {
  If ($PSScriptRoot -eq '') {
    Write-Output 'Downloading Github Repository …'
    $cleanup = $TRUE

    $tempPath = (Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName()))
    New-Item -ItemType Directory -Path $tempPath | Out-Null

    $dotfilesDir = (Join-Path $tempPath 'dotfiles')
    $dotfilesZip = "$dotfilesDir.zip"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri 'https://github.com/reitermarkus/dotfiles/archive/windows.zip' -OutFile $dotfilesZip

    try {
      Expand-Archive -Path $dotfilesZip -DestinationPath $tempPath -Force
      Move-Item -Path (Join-Path $tempPath 'dotfiles-windows') -Destination $dotfilesDir
    } finally {
      Remove-Item $dotfilesZip -Force
    }
  }

  . (Join-Path $dotfilesDir (Join-Path 'settings' 'default_apps.ps1'))
  . (Join-Path $dotfilesDir (Join-Path 'settings' 'disable_uac.ps1'))
  . (Join-Path $dotfilesDir (Join-Path 'settings' 'natural_scrolling.ps1'))

  . (Join-Path $dotfilesDir (Join-Path 'install' 'chocolatey.ps1'))
  . (Join-Path $dotfilesDir (Join-Path 'install' 'bootcamp.ps1'))
} finally {
  If ($cleanup) {
    Remove-Item $dotfilesDir -Force -Recurse
  }
}
