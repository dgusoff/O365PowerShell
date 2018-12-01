
$subscriptionName = "Azure Free Trial"
$resourceGroupName = "my-resource-group"
$storageAccountName = "storageaccountName"
$queueName = "myqueue"
$filePath = "C:\Users\derek\Desktop\sites.csv"


Connect-AzureRmAccount


Get-AzureRmSubscription

Select-AzureRmSubscription -Subscription $subscriptionName

Install-Module AzureRmStorageQueue
$account = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName  -Name $storageAccountName

$queueName = $queueName
$queue = Get-AzureStorageQueue -Name $queueName -Context $account.Context

Import-Csv $filePath | % {
$url = $_.SiteURL
$queueMessage = New-Object -TypeName Microsoft.WindowsAzure.Storage.Queue.CloudQueueMessage -ArgumentList "$url"
    if($url.Length -gt 0){
        $queue.CloudQueue.AddMessage($QueueMessage)
        write-host -ForegroundColor Green $url
    }
    else{
    break
    }
}
