#####################################################
#                                                   #
# Copy List to New Site.ps1                         #
# Copies a list structure from one site to another  #
#                                                   #
# Derek Gusoff
# https://github.com/dgusoff
# September 20, 2017
#                                
#####################################################


if($cred -eq $null){
    $cred = get-credential
}

function CopyList( $sourceUrl, $listName, $destinationUrl, $cred){

    #get source list and fields
    Connect-PnPOnline -Url $sourceUrl -Credentials $cred
    $list = Get-PnPList -Identity $listName
    $listTemplate = $list.BaseTemplate  
    $sourceFields = Get-PnPField -List $listName
    Disconnect-PnPOnline

    #create destination list
    Connect-PnPOnline -Url $destinationUrl -Credentials $cred
    $newList = New-PnPList -Template $listTemplate -Title $listName
    $newListFields =  Get-PnPField -List $listName

    $sourceFields | % {
        if(ItemisInArray $newListFields $_.InternalName)
        {
            #Write-Host $_.InternalName -ForegroundColor White
        }
        else
        {
            $fieldName = $_.Title
            $fieldXml = $_.SchemaXml
            Write-Host "Adding column $fieldName." -ForegroundColor Green     
            
            $gulp = Add-PnPFieldFromXml -List $listName -FieldXml $fieldXml      
        }
    }
    Disconnect-PnPOnline
}

function ItemIsInArray($arr, $checkValue ){
    $found = $false

    $arr | % {
        if($_.InternalName -eq $checkValue){
        return $true
        }
    }
}

#usage
$sourceSiteUrl = "https://derek.sharepoint.com/sites/sourcesite"
$destinationSiteUrl = "https://derek.sharepoint.com/sites/destinationsite"
$destinationListTitle = "Destination List"


CopyList $sourceSiteUrl $destinationListTitle $destinationSiteUrl $cred