function Test-RedirectResponseIsHttps {
  param
  (
    [Parameter(Mandatory)]
    [Object]$Response
  )
  return ($null -ne $response) -and ($null -ne $Response.ResponseUri) -and ('https' -eq $Response.ResponseUri.Scheme)
}


function Test-RedirectDnsName {
  param
  (
    [Parameter(Mandatory)]
    [string]$DnsName
  )
  $result = $null
  try {
    $response = ($null -ne $response) -and (Invoke-WebRequest -URI "http://$DnsName")
    $result = Test-RedirectResponseIsHttps -Response $response
  }
  catch {
    $response = $_.Exception.Response
    if ($null -ne $response) {
      $result = Test-RedirectResponseIsHttps -Response $response
    }
    else {
      Write-Host $_.Exception
      $result = $false
    }
  }
  return $result
}

function Get-HTTPDnsNamesFromBindings {

  $dnsNames = Get-Website | ForEach-Object {
    $website = $_
    $bindings = $website.Bindings
    return $bindings.Collection
  } | Where-Object { $_.protocol -like 'http' } | ForEach-Object { $_.bindingInformation.substring($_.bindingInformation.LastIndexOf(':') + 1) }
  return $dnsNames
}

function Test-EnsureRedirectionHTTPToHTTPS {
  $dnsNames = Get-HTTPDnsNamesFromBindings
  $results = $dnsNames | ForEach-Object { Test-RedirectDnsName -DnsName $_ }
  return $results -notcontains $false
}

function New-EnsureRedirectionHTTPToHTTPS {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest -TestBlock { Test-EnsureRedirectionHTTPToHTTPS } `
    -Description "Ensure HTTP requests are properly redirected to HTTPS." `
    -Number "${TestNumberPrefix}.13"
    
  return $newTest
}

Export-ModuleMember -Function * 