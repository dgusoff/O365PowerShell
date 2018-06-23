# create a bunch of SP Online sites

$tenant = "m365x234372"
$userName = "admin@M365x234372.onmicrosoft.com"
$seed = "groupsTest"
$numSites = 10
$template = "BLANKINTERNETCONTAINER#0"
$quota = 1024

Connect-SPOService

for ($i = 0; $i -lt $numSites; $i++){
   $siteTitle = $seed + $i
   New-SPOSite -Url "https://$tenant.sharepoint.com/sites/$siteTitle" -Owner $userName -Title "$siteTitle" -Template $template -StorageQuota $quota -NoWait
}
