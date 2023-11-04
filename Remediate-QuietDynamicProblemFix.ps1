$RegPath = "HKLM:\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"

IF (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -Type Directory -Force
    }

Set-ItemProperty -Path $RegPath -Name "Allowed Entities" -Value "ZaskeDev\MZD-MMA-$($env:ComputerName)" -Type MultiString -Force
Set-ItemProperty -Path $RegPath -Name "Override Removal By Outside Process" -Value 1 -Type DWORD -Force
Set-ItemProperty -path $RegPath -Name "Remove Admin Rights On Logout" -Value 1 -Type DWORD -Force
Set-ItemProperty -path $RegPath -Name "Denied Entities" -Value "ZaskeDev\MZD-MMA-Denied" -Type MultiString -Force

$DetectRegValueName = "MMAGroupFix"
$DetectFullRegKeyName = "HKLM:\SOFTWARE\localit\" 

If (!(Test-Path $DetectFullRegKeyName)) {
    New-Item -Path $DetectFullRegKeyName -Type Directory -Force 
    }

New-ItemProperty -Path $DetectFullRegKeyName -Name $DetectRegValueName -Value "1" -Type STRING -Force
