$DetectRegValueName = "MMAGroupFix"
$DetectFullRegKeyName = "HKLM:\SOFTWARE\localit\" 

try {
    Get-ItemProperty -Path $DetectFullRegKeyName -ErrorAction Stop | Select-Object -ExpandProperty $DetectRegValueName -ErrorAction Stop | Out-Null
    return $true
}
catch {
    return $false
}
