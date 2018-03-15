Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Enum\HID\*\*\Device` Parameters FlipFlopWheel -EA 0 | ForEach-Object {
  Set-ItemProperty $_.PSPath FlipFlopWheel 1
}
