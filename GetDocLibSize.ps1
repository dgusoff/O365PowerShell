# GetDocLibSize.ps1
# outputs the total size, in MBs of a document library's contents
# Derek Gusoff, Rightpoint
# https://github.com/dgusoff

$siteUrl = https://<tenant>.sharepoint.com/sites/site -Credentials MyCreds
$listTitle = "Documents"

Connect-PnPOnline $siteUrl

$docLibSize = 0
Get-PnPListItem -List $listTitle | % {

$docLength = $_["File_x0020_Size"]
    $title = $_["Title"]
    Write-Host "$title = $docLength"
    $docLibSize += $docLength

}

Write-Host "---------"
$docsLibSizeInMB = $docLibSize / 1000000
Write-Host "Total Doc Size: $docsLibSizeInMB MB"
