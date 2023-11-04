$RegPath = "HKLM:\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"
$RegPathExists = Test-Path $RegPath
$groupName = "ZaskeDev\MZD-MMA-$($env:COMPUTERNAME)"

$Compliance = $false

if($RegPathExists) {
    $AllowedEntities = (Get-ItemPropertyValue $RegPath  -Name "Allowed Entities" -ErrorAction SilentlyContinue) -eq $groupName
    $DeniedEntities = (Get-ItemPropertyValue $RegPath -Name "Denied Entities" -ErrorAction SilentlyContinue) -eq "ZaskeDev\MZD-MMA-Denied"
    $RemoveAdminOnLogout = (Get-ItemPropertyValue $RegPath -Name "Remove Admin Rights On Logout" -ErrorAction SilentlyContinue) -eq 1
    $OverriveRemoval = (Get-ItemPropertyValue $RegPath -Name "Override Removal By Outside Process" -ErrorAction SilentlyContinue) -eq 1
    $DefaultTimeout = (Get-ItemPropertyValue $RegPath -Name "Admin Rights Timeout" -ErrorAction SilentlyContinue) -eq 15

    if($AllowedEntities -and $DeniedEntities -and $RemoveAdminOnLogout -and $OverriveRemoval -and $DefaultTimeout){
        $Compliance = $true
    }
}

$Compliance
