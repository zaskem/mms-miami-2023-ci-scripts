$DetectRegValueName = "MMAGroupFix"
$DetectFullRegKeyName = "HKLM:\SOFTWARE\localit\" 

try {
  Get-ItemProperty -Path $DetectFullRegKeyName -ErrorAction Stop | Select-Object -ExpandProperty $DetectRegValueName -ErrorAction Stop | Out-Null
  exit 0
}
catch {
  exit 1
}
