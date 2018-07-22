#ISV data 
# get all this from outside 
#$storageAccount = "be1byos1sa"
#$storageAccountKey = "5Pm1qvULZkak4O6Kf4Gf8QI2z0tnQeRMWP6zkXMONGtMgqHe4foPwXJYme5Pi/tbbhFWdlG7m+2rxHN7B8+/9w=="
#$copyBlobName = "model.dplx"
#$copySrcURI = "https://be1byos1sa.blob.core.windows.net/bcont0/"
#$copyFullURI = $copySrcURI + $copyBlobName




# POST method: $req
$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$name = $requestBody.name
$containerName = $requestBody.containerName

$storageAccount = $requestBody.storageAccount
$storageAccountKey = $requestBody.storageAccountKey
$copyBlobName = $requestBody.copyModelName
$copySrcURI = $requestBody.copySrcURI
$copyFullURI = $copySrcURI + $copyBlobName



$sac = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageAccountKey


$haveContainer = 0
try {
    $cont =  Get-AzureStorageContainer -Name $containerName -ErrorAction stop -Context $sac
	$haveContainer = 1
} 
catch { 
    $haveContainer = 0
}

if($haveContainer){
    $outStr = "Container already exists"
}else{
    New-AzureStorageContainer -Name $containerName -Permission Blob -Context $sac
    $outStr = "New container created:" + $containerName
}

#######Copy model.dplx
Start-AzureStorageBlobCopy -AbsoluteUri $copyFullURI -DestContainer $containerName -DestContext $sac -DestBlob $copyBlobName -Force

$outStr = $outStr + "; And " + $copyBlobName + " copied inside"

write-host $outStr
#todo Write-EventLog 
#Remove-AzureRmAccount

Out-File -Encoding Ascii -FilePath $res -inputObject $outStr