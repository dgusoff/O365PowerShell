###########################################################
# BulkAddToQueue-v2.ps1
# 
# Shows How to dump a bunch of stuff on an Azure queue
# Uses the newer "Az" PS packages
#
# Derek Gusoff, github.com/dgusoff
# December 02, 2019
#########################################################3

#set up variables
$accountName = "xxx"
$accountKey = "xx"
$numberOfItems = 100
$stub = (get-date).Ticks

$queueName = "my-queue"

## fetch a context
$ctx = New-AzStorageContext -StorageAccountName $accountName -StorageAccountKey $accountKey

# fetch a queue by name
$queue = Get-AzStorageQueue –Name $queueName –Context $ctx

$i = 0;


for($i = 0; $i -lt $numberOfItems; $i++){
    $json = "{'siteUrl':'" + $stub + $i + "','siteTitle':'test Site " + $i + "'}"
    $qmsg = New-Object Microsoft.WindowsAzure.Storage.Queue.CloudQueueMessage $json
    $queue.CloudQueue.AddMessage($qmsg)

    Write-Host "added $i" -ForegroundColor Green
}
