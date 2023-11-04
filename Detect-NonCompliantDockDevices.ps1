$CurrentVersionString = '0001.0000.0041.0001'
$logPath = "C:\Windows\Temp\DockFirmareCI.log"
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

try {
    $WMIData = get-wmiobject -namespace root\dell\sysinv dell_softwareidentity -ErrorAction Stop
    $DellData = $WMIData | select-object versionstring, elementname | where-object elementname -like "*WD19*" | sort-object elementname
    $RecordCount = $DellData | measure-object

    if ($RecordCount.count -gt 0) { 
        if ($RecordCount.count -gt 1) {
            $logText = "ERROR: MULTIPLE DOCK DATA"
            Write-Log -Message $logText -Path $logPath
            return $false
        } else {
            if ($DellData.versionstring -lt $CurrentVersionString) {
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
        $logText = "ERROR: NO DOCK CONNECTED"
        Write-Log -Message $logText -Path $logPath
        return $false
    }
} catch {
    $logText = "ERROR: LOAD WMI"
    Write-Log -Message $logText -Path $logPath
    return $false
}
