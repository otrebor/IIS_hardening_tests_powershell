function Get-ApplicationPoolIdentity {
    $webapps = Get-ChildItem -Path 'IIS:\AppPools'
    $list = [System.Collections.ArrayList]::new()
    foreach ($webapp in $webapps) {
        $Pool = 'IIS:\AppPools\' + $webapp.name
        $sid = New-Object System.Security.Principal.SecurityIdentifier (
            Get-Item $Pool | Select-Object -ExpandProperty applicationPoolSid
        )
        [void]$List.add([PSCustomObject]@{
            Name = $webapp.name
            Pool = $Pool
            ServiceAccount = $sid.Translate([System.Security.Principal.NTAccount])
        })
    }
    return $list
}

Export-ModuleMember -Function Get-ApplicationPoolIdentity