# function Get-RequireSSLInfo {
#   return Get-Website | Foreach-Object {
#     $config = (Get-WebConfiguration -Filter 'system.web/authentication' -PSPath "IIS:\sites\$($_.Name)")
  
#     If ($config.mode -EQ 'forms') {
#         [PSCustomObject]@{
#             "Name" = $_.Name
#             "SSL"  = $config.Forms.RequireSSL
#         }
#     }
#   }
# }

# function Test-SensitiveFeaturesIsRestricted {
#     $results = Get-RequireSSLInfo | ForEach-Object {
#         return $_.Principals
#     }
#     Write-Information "sensitive site features is restricted to authenticated principals only"
#     return $results -notcontains $false
# }

Export-ModuleMember -Function *