#######################
# UserProfileImageImport.ps1
# by Derek Gusoff
# https://github.com/dgusoff
# June 22, 2018
# 
#
# 1. Update the variables section with:
# -- username, folder path, domain, and admin urls
# 2. create a folder at the location specified in $strPath and add the image files.  
# -- the filename should match the user's login name, ex. dgusoff.jpg
# 3. run the script
# 4. smoke test a profile to verify success
# 5. delete the files from the folder
##########################################


#########################
## Variables
#########################
$userDomain = "M365x267977.onmicrosoft.com"
$strPath = "C:\users\derek\desktop\photos"
$tenant = "M365x267977"


$scriptuser = "admin@$userDomain"
$mySiteUrl = "https://$tenant-my.sharepoint.com"
$adminUrl = "https://$tenant-admin.sharepoint.com"

if($Cred -eq $null){
    $Cred = get-credential -UserName $scriptuser -Message "Please enter your password"
} 

cls

#########################
## Functions
#########################

function ResizeImageLarge($fileNameFull, [int]$newWidth){
 try{
        
        [System.Drawing.Image]$originalimage = [System.Drawing.Image]::FromFile($fileNameFull)
        $newHeight = ($newWidth * $originalimage.Height) / $originalimage.Width;

        $newImage = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $rect = New-Object System.Drawing.Rectangle(0,0, $newWidth, $newHeight)
        $gr = [System.Drawing.Graphics]::FromImage($newImage)
        $gr.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $gr.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $gr.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

        $gr.DrawImage($originalimage, $rect)

        $gr.Dispose
        return [System.Drawing.Image]$newImage
    }
    catch{
    $_
        return $null
    }
}


function SaveImageToSharePointUserPhotos($ctx, $bytes, $fileName){
    $web = get-pnpweb

    $info = New-Object Microsoft.SharePoint.Client.FileCreationInformation
    $info.Content = $bytes
    $info.Overwrite = $true
    $info.Url = $fileName
    

    $folder = $web.GetFolderByServerRelativeUrl("/User Photos/Profile Pictures")
    $upload = $folder.Files.Add($info)
    $ctx.Load($upload)
    $ctx.ExecuteQuery()
}

function ConvertImageToBytes($image){
    $ms = New-Object System.IO.MemoryStream
    $image.Save($ms, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bytes = $ms.ToArray()
    $ms.Dispose()
    return $bytes
}

#########################
## Main
#########################

# set array of pictures to update
$arrFileNames = Get-ChildItem -Path $strPath -Name -File
$numFiles = $arrFileNames.Length

write-host "found $numFiles image files."

foreach ($strFileName in $arrFileNames) {
    $keepGoing = $true
    write-host "Reading file $strFileName"
    #Get file base name without extension
    $strFileBase = [io.path]::GetFileNameWithoutExtension($strFileName)
    $strFileBaseFull = $strPath + $strFileBaseFull
    $strFileNameFull = "$strPath\$strFileName"

    #Set Photo
	$photo = [byte[]](Get-Content $strPath\$strFileName -Encoding byte)
    write-host "Got the photo bytes"
     $userName = "$strFileBase@$userDomain"

    if($keepGoing){
        
    $userLoginFixed = $userName.Replace("@", "_").Replace(".", "_");

    $filePathM =  [System.String]::Format("/User Photos/Profile Pictures/{0}_{1}Thumb.jpg", $userLoginFixed, "M")
    $filePathL =  [System.String]::Format("/User Photos/Profile Pictures/{0}_{1}Thumb.jpg", $userLoginFixed, "L")
    $filePathS =  [System.String]::Format("/User Photos/Profile Pictures/{0}_{1}Thumb.jpg", $userLoginFixed, "S")

    Connect-PnPOnline -Url $mySiteUrl -Credentials $cred
    $ctx = Get-PNPContext

    try{  
        $smallImg = ResizeImageLarge $strFileNameFull 48   
        $bytes = ConvertImageToBytes  $smallImg[1]  
        SaveImageToSharePointUserPhotos $ctx $bytes $filePathS
        write-host "resized the small image"

        $mediumImg = ResizeImageLarge $strFileNameFull 72
        $bytes = ConvertImageToBytes  $mediumImg[1] 
        SaveImageToSharePointUserPhotos $ctx $bytes $filePathM
        write-host "resized the medium image"

        $largeImg = ResizeImageLarge $strFileNameFull 300
        $bytes = ConvertImageToBytes  $largeImg[1]  
        SaveImageToSharePointUserPhotos $ctx $bytes $filePathL      
        write-host "resized the large image"

        write-host "Files updated in SharePoint for $userName"
    }
    catch{
    write-host "oops"
         write-host $_ -ForegroundColor Yellow
         write-host
    }
    finally{       
    }
   }
   Connect-PnPOnline -Url $adminUrl  -Credentials $cred
   $picurl = $mySiteUrl + $filePathM
   Write-Host "setting picture url for user $userName to $picUrl"
   
   Set-PNPUserProfileProperty -Account $userName -PropertyName "PictureURL" -Value $picUrl -ErrorAction Stop

}