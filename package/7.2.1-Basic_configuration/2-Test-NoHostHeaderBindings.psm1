

function Test-NoHostHeaderBindings {
    $results = Get-WebBinding | ForEach-Object {
        $obj = $_

        $bindingInfo = $obj.bindingInformation -split ':'
        
        $protocol = $obj.protocol
        $bindingInfoTable = @{ 
            ipAddress = $bindingInfo[0];
            port      = $bindingInfo[1];
            hostName  = $bindingInfo[2];
            protocol  = $protocol;
        }
        Write-Output $bindingInfoTable
        Write-Output ""

        if ($bindingInfoTable.hostName -like "") {
            Write-Warning "Binding $bindingInfoTable does not have an hostname"
            return $false;
        }
        return $true
    }
    return $results -notcontains $false
}

function New-NoHostHeaderBindings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-NoHostHeaderBindings } `
        -Description "Ensure 'host headers' are on all sites" `
        -Number "${TestNumberPrefix}.2"

    return $newTest
}

Export-ModuleMember -Function *
