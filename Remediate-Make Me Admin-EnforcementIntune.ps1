#
# Sets the Make Me Admin registry keys
#
$RegPath = "HKLM:\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"
$PathExist = Test-Path $RegPath

# Create registry key path if it does not exist
If (-not(Test-Path $RegPath)) {
    New-Item $RegPath -ItemType Directory -Force
}
# Set the new Allowed Entities registry key
Set-ItemProperty -Path $RegPath -Name "Allowed Entities" -Value "ZaskeDev\MZD-MMA-$($env:ComputerName)" -Type MultiString -Force
# Set the new Denied Entities registry key
Set-ItemProperty -path $RegPath -Name "Denied Entities" -Value "ZaskeDev\MZD-MMA-Denied" -Type MultiString -Force
# Set administration keys
Set-ItemProperty -Path $RegPath -Name "Override Removal By Outside Process" -Value 1 -Type DWORD -Force
Set-ItemProperty -path $RegPath -Name "Remove Admin Rights On Logout" -Value 1 -Type DWORD -Force
Set-ItemProperty -Path $RegPath -Name "Admin Rights Timeout" -Value 15 -Type DWORD -Force

Exit 0