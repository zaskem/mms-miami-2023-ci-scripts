# Define Model List and Version Targets
$ModelList = @{
    '5400' = '0001.0024.0000'
    '5420' = '0001.0029.0000'
    '5430' = '0001.0013.0001'
    '5440' = '0001.0005.0000'
}

$logPath = "C:\Windows\Temp\LatitudeBIOSCI.log"
Function Write-Log {
    <#
        .SYNOPSIS
            This function is used to pass messages to a ScriptLog.  It can also be leveraged for other purposes if more complex logging is required.
        .DESCRIPTION
            Write-Log function is setup to write to a log file in a format that can easily be read using CMTrace.exe. Variables are setup to adjust the output.
        .PARAMETER Message
            The message you want to pass to the log.
        .PARAMETER Path
            The full path to the script log that you want to write to.
    #>

    PARAM(
        [Parameter(Mandatory=$True)][String]$Message,
        [Parameter(Mandatory=$True)][String]$Path
    )
            
    # Setup the log message
    
        $time = Get-Date -Format "HH:mm:ss.fff"
        $date = Get-Date -Format "MM-dd-yyyy"
        $LogMsg = '<![LOG['+$Message+']LOG]!><time="'+$time+'+000" date="'+$date+'">'
            
    # Write out the log file using the ComObject Scripting.FilesystemObject
    
        $ForAppending = 8
        $oFSO = New-Object -ComObject scripting.filesystemobject
        $oFile = $oFSO.OpenTextFile($Path, $ForAppending, $True)
        $oFile.WriteLine($LogMsg)
        $oFile.Close()
        Remove-Variable oFSO
        Remove-Variable oFile
        
}

if (((Get-WmiObject win32_computersystem).Manufacturer).StartsWith("Dell", $true, $null)) {
    $ModelNumber = (Get-WmiObject win32_computersystem).Model -replace '\D+(\d+)', '$1'
    if ($ModelList.ContainsKey($ModelNumber)) {
        try {
            $WMIData = Get-WmiObject -Namespace root\dell\sysinv dell_softwareidentity -ErrorAction Stop
            $DellData = $WMIData | Select-Object VersionString, ElementName | Where-Object ElementName -like "*BIOS*" | Sort-Object ElementName
            $RecordCount = $DellData | Measure-Object

            if ($RecordCount.count -gt 0) { 
                if ($RecordCount.count -gt 1) {
                    $logText = "ERROR: MULTIPLE DATA"
                    Write-Log -Message $logText -Path $logPath
                    return $false
                } else {
                    if ($DellData.versionstring -lt $ModelList[$ModelNumber]) {
                        $logText = "FIRMWARE OLD"
                        Write-Log -Message $logText -Path $logPath
                        return $false
                    } else {
                        $logText = "FIRMWARE OK"
                        Write-Log -Message $logText -Path $logPath
                        return $true
                    }
                } 
            } else {
                $logText = "ERROR: NO DATA"
                Write-Log -Message $logText -Path $logPath
                return $false
            }
        }
        catch {
            $logText = "ERROR: LOAD WMI"
            Write-Log -Message $logText -Path $logPath
            return $false
        }
    } else {
        $logText = "ERROR: MODEL OUT OF SCOPE"
        Write-Log -Message $logText -Path $logPath
        return $false
    }
} else {
    $logText = "ERROR: NOT A DELL DEVICE"
    Write-Log -Message $logText -Path $logPath
    return $false
}
