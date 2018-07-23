#
# PowerShellProjectDeployByos.ps1
#
$mySubscriptionID = "78e47976-009f-4d4a-a961-6046cdabf459"
$destinationResourceGroup = "be_trydest35_rg"
$resourceGroupLocation = "West US"
$myAccountID = "boefraty@microsoft.com"
#$PSScriptRoot
$scriptRoot = "c:\Users\boefraty\projects\PBI\InsightApps\ARM\PowerShellProjectDeployByos\PowerShellProjectDeployByos"

$prefix = ""
$postfix = "try35"


# sign in
Write-Host "Logging in...";
$getAccount = Get-AzureAccount
if (Compare-Object $getAccount.Id $myAccountID) # TODO: not enough
{
	#Add-AzureAccount
	Connect-AzureRmAccount    
}
else
{
     Write-Host "Already connected"     
}


# select subscription
Write-Host "Selecting subscription '$mySubscriptionID'";
Get-AzureRmSubscription
Select-AzureRmSubscription  -SubscriptionId $mySubscriptionID


#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $destinationResourceGroup -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$destinationResourceGroup' does not exist. Will be created.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$destinationResourceGroup' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $destinationResourceGroup -Location $resourceGroupLocation -Force
}
else{
    Write-Host "Using existing resource group '$destinationResourceGroup'";
}


#test template 
Test-AzureRmResourceGroupDeployment -ResourceGroupName $destinationResourceGroup `
  -TemplateFile "$scriptRoot\template.json"


$Deployment = @{
	Name = "beDeployment";
	ResourceGroupName = $destinationResourceGroup;
	Mode = "Complete"
	TemplateFile = "$scriptRoot\template.json";
	TemplateParameterObject = @{
		storageAccounts_be1byos1sa_name = $prefix + "be1byos1sa" + $postfix;
		vaults_be1byos1kv_name = $prefix + "be1byos1kv" + $postfix;
		sites_be1byos1serviceApps_name =  $prefix + "be1byos1serviceApps" + $postfix;
		sites_be1byos1serviceAppKeyVault_name =  $prefix + "be1byos1serviceAppKeyVault" + $postfix;
		workflows_be_insideInstaller_la_name = "be_insideInstaller_la";
		workflows_be_byos_refresh_data_la_name = "workflows_be_byos_refresh_data_la";
		}
	Force = $true;
}


# Start the deployment
Write-Host "Starting deployment...";
#New-AzureRmResourceGroupDeployment -Name  beDeployment  -ResourceGroupName $destinationResourceGroup -Mode Complete -TemplateFile  $PSScriptRoot\template.json  -TemplateVersion "2.1" -Force
New-AzureRmResourceGroupDeployment  @Deployment



# copy template data into azure storage 
#get storage key 
$storageKeys = Get-AzureRmStorageAccountKey  -ResourceGroupName $destinationResourceGroup -Name $Deployment.TemplateParameterObject.storageAccounts_be1byos1sa_name
$keyString = $storageKeys.GetValue(0).Value

$asc = New-AzureStorageContext -StorageAccountName $Deployment.TemplateParameterObject.storageAccounts_be1byos1sa_name -StorageAccountKey $keyString

#create containers
New-AzureStorageContainer -Name "static" -Permission Blob -Context  $asc 
New-AzureStorageContainer -Name "refreshdata" -Permission Blob -Context  $asc 

#copy blob
Set-AzureStorageBlobContent -Container "static" -File "c:\Users\boefraty\projects\PBI\InsightApps\ARM\PowerShellProjectDeployByos\PowerShellProjectDeployByos\data\model.dplx" -Blob "model.dplx" -Context $asc -Force

$filepath = "c:\Users\boefraty\projects\PBI\InsightApps\ARM\PowerShellProjectDeployByos\PowerShellProjectDeployByos\data\MapUsers2Resources.csv"
$tableName = "MapUsers2Resources"

#create table 
New-AzureStorageTable –Name $tableName –Context $asc
$storageTable = Get-AzureStorageTable –Name $tableName –Context $asc

$csv = Import-CSV $filepath
$cArray = ("Company","DisplayName","GUID","Token")

foreach($line in $csv)
{
	#Write-Host "$($line.partitionkey), $($line.rowKey)"
   $entity = New-Object -TypeName Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity -ArgumentList $line.partitionkey, $line.rowKey 
  
   foreach($c in $cArray)
	{
		#Write-Host "$c,$($line.$c)"
        $entity.Properties.Add($c,$line.$c)
	}       
	  $result = $storageTable.CloudTable.Execute([Microsoft.WindowsAzure.Storage.Table.TableOperation]::Insert($entity))
}

# get column names 
$aaa = $csv.Get(0)
$bbb = $aaa.PSObject.Properties | Select-Object -Expand Name



# create key vault + AAD 
$myscope = "/subscriptions/" + $mySubscriptionID  + "/resourceGroups/" +  $destinationResourceGroup + "/providers/Microsoft.KeyVault/vaults/" + $Deployment.TemplateParameterObject.vaults_be1byos1kv_name
New-AzureRmRoleAssignment -ApplicationId "00000009-0000-0000-c000-000000000000" -RoleDefinitionName "Reader" –Scope $myscope



#TODO: 
#save data 
# subscriptionID, tenantID, upn, storagePrimeKey, storageName, resourceGroupName,
Write-Host '"storagePrimeKey" = '  $keyString
Write-Host '"tenantID" = '  $getAccount.Tenants[0]
Write-Host '"upn" = '  $myAccountID
Write-Host '"subscriptionID" = '  $mySubscriptionID
Write-Host '"storageName" = '  $Deployment.TemplateParameterObject.storageAccounts_be1byos1sa_name
Write-Host '"resourceGroupName" = '  $destinationResourceGroup
Write-Host '"LogicAppPost" = '  $keyString
Write-Host  '"storageRootURL" = ' $asc.BlobEndPoint