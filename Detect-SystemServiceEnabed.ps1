If ((Get-Service -Name "PhoneSvc" | Select-Object -Property StartType).StartType -eq "Disabled") {
    return $True
} else {
    return $False
}
