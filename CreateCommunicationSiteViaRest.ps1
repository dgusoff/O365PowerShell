# what is this?
#
# POC script to create a modern communication site using a REST request

# Configuration
$TenantUrl = "https://m365x481547.sharepoint.com"
$Username = "admin@M365x481547.onmicrosoft.com"
$Password = "password"

$SiteTitle = "My Communication Site 1"
$SiteUrl = "https://m365x481547.sharepoint.com/sites/mycomsite1" # Note this URL must be available (check with "/_api/GroupSiteManager/GetValidSiteUrlFromAlias")
$SiteTemplate = "" # "Topic" => leave empty (default), "Showcase" => "6142d2a0-63a5-4ba0-aede-d9fefca2c767" and "Blank" => "f6cc5403-0d63-442e-96c0-285923709ffc"

# Communication site creation request
$RequestBody = '{"request":{"__metadata":{"type":"SP.Publishing.PublishingSiteCreationRequest"},"Title":"' + $SiteTitle + '","Url":"' + $SiteUrl + '","Description":"","Classification":"","SiteDesignId":"' + $SiteTemplate + '","AllowFileSharingForGuestUsers":false}}'

if ($SiteTemplate -eq "")
{
    $RequestBody = '{"request":{"__metadata":{"type":"SP.Publishing.PublishingSiteCreationRequest"},"Title":"' + $SiteTitle + '","Url":"' + $SiteUrl + '","Description":"","Classification":"","AllowFileSharingForGuestUsers":false}}'
}

# Get a user based context for SharePoint (app credentials not supported for this approach)
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($TenantUrl)
$Context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $(ConvertTo-SecureString -AsPlainText $Password -Force))
$Context.ExecuteQuery()

# Get url, cookie and forms digest for authentication
$RequestUrl = "$($TenantUrl)/_api/sitepages/publishingsite/create"
$AuthenticationCookie = $Context.Credentials.GetAuthenticationCookie($TenantUrl, $true)
$FormsDigest = $Context.GetFormDigestDirect()

$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$WebSession.Credentials = $Context.Credentials
$WebSession.Cookies.SetCookies($TenantUrl, $AuthenticationCookie)

$Headers = @{ 
    'X-RequestDigest' = $FormsDigest.DigestValue;
    'accept' = 'application/json;odata=verbose';
    'content-type' = 'application/json;odata=verbose' }

# Call REST API to create new site
$Result = Invoke-RestMethod -Method Post -WebSession $WebSession -Headers $Headers -ContentType "application/json;odata=verbose;charset=utf-8" -Body $RequestBody -Uri $RequestUrl -UseDefaultCredentials

$Context.Dispose()

# Site has been created
Write-Output "New site created at: $($Result.d.Create.SiteUrl)"
