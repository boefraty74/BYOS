# POST method: $req
$rB = Get-Content $req -Raw | ConvertFrom-Json
$name = $rB.name

#template Body with defaults
$Body = @{
    #ISV data
    resourceGroupName =  "be_byos_rg"
    storageName = "be1byos1sa"
    storagePrimeKey = "5Pm1qvULZkak4O6Kf4Gf8QI2z0tnQeRMWP6zkXMONGtMgqHe4foPwXJYme5Pi/tbbhFWdlG7m+2rxHN7B8+/9w=="
    vaultName = "be1byos1kv"
    ISVsubscriptionID = "78e47976-009f-4d4a-a961-6046cdabf459"
    ISVworkspaceID = "" #TO REMOVE
    ISVtenantId =  "72f988bf-86f1-41af-91ab-2d7cd011db47"
    storageRootURL = "https://be1byos1sa.blob.core.windows.net/"
    templateContainer = "static"
    tableMapResources = "MapUsers2Resources"
    modelFile = "model.dplx"
    csvFile = "datapool.csv"
    ADappPassword = "mli345daLo"
    ADappID = "29081819-cede-4059-a2e0-e0d62657cd27"
    ADappName = "be1new1azure1ad1app"


    #Installer User Data
    kustoCluster = "Lxprdpbi"
    kustoDatabase = "PowerBI"
    kustoQuery = "event |where timestamp > endofday(ago(30d)) |  where timestamp < startofday(ago(0d)) | limit 100| summarize count() by bin(timestamp, 1h) "
	containerName = "newcontainernamemicrosoft"
    datapoolName = "newDatapoolBEIlitia1"
	description = "My new external datapool"
	subscriptionId =  "78e47976-009f-4d4a-a961-6046cdabf459"
    tenantId =  "72f988bf-86f1-41af-91ab-2d7cd011db47"
	secretPath = "newSecret108"
    workspaceID = "7f7fd00f-b825-468d-97a5-f60853cffc79"
    upn = "boefraty@microsoft.com"
    userQuerySelectionID = "Microsoft" #"Microsoft" # "MSR" # "Ilitia"
    userParam1 = 30 # max days (TODO)
    userParam2 = 2 # max visuals (TODO)
    Authorization =  "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSIsImtpZCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3LyIsImlhdCI6MTUzMDE2NjU4MSwibmJmIjoxNTMwMTY2NTgxLCJleHAiOjE1MzAxNzA0ODEsImFjciI6IjEiLCJhaW8iOiJBVlFBcS84SEFBQUE4UEpGMEhpb2VBckJ0RVBkcU9FZFVnUml6NVMxUGE0MWZlRXhBbVM1dFE3cjh5OUpQeHd6Qi95all3SXRSMUhaWXpES3NQMkhrOFRVSHdERTBoL1J6YWZ6ay94T2M0dXBKRnBmOUxuVlp0VT0iLCJhbXIiOlsicHdkIiwicnNhIiwibWZhIl0sImFwcGlkIjoiODcxYzAxMGYtNWU2MS00ZmIxLTgzYWMtOTg2MTBhN2U5MTEwIiwiYXBwaWRhY3IiOiIyIiwiZGV2aWNlaWQiOiI2ZTlmOWUzMS03MzM0LTQyNGQtYTgwZS05MTZiZDBmNDM1MDMiLCJlX2V4cCI6MjYyODAwLCJmYW1pbHlfbmFtZSI6IkVmcmF0eSIsImdpdmVuX25hbWUiOiJCb3JpcyIsImluX2NvcnAiOiJ0cnVlIiwiaXBhZGRyIjoiMTY3LjIyMC4xOTYuMTkwIiwibmFtZSI6IkJvcmlzIEVmcmF0eSIsIm9pZCI6IjcxZWFkNjczLWNiNWMtNGU2ZC1hMDBmLTMzNzA3MGUzOWU3YSIsIm9ucHJlbV9zaWQiOiJTLTEtNS0yMS03MjA1MTYwNy0xNzQ1NzYwMDM2LTEwOTE4Nzk1Ni0yMjY5MDUiLCJwdWlkIjoiMTAwMzNGRkY4RERGNzZEMCIsInNjcCI6InVzZXJfaW1wZXJzb25hdGlvbiIsInN1YiI6Ik8yc0ZKMnlLR2Q5bVVQYjk2RFVtd2RBc2xUYUE0Ul93RjhXYjFiR29jbEEiLCJ0aWQiOiI3MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDciLCJ1bmlxdWVfbmFtZSI6ImJvZWZyYXR5QG1pY3Jvc29mdC5jb20iLCJ1cG4iOiJib2VmcmF0eUBtaWNyb3NvZnQuY29tIiwidXRpIjoiMWFGWEd5VlhOVUNMTVd1NjFYa0NBQSIsInZlciI6IjEuMCJ9.MrlYkIYSUVRCZLsB_cnl0Nk2l5WhBW90GW83o1pKUIZZml6fan6WddNs5A6-9xtykkbpBHhtfmsQ2AlZyEjyW9FpRhHcylgBtwUqCiBkzsoi459xZeTsdmNXEvej9HGuchtWNCsI52ujRIPMjz4N-DhunU6fAQyw-Ix1S8UG-2j4DeNMuYXhhYY1-8Ee7kqGxSDYReMxNU70-WmvjUFwaJ2iD7BZGoGoAvjA7c6AZoXe1rW5buuHJx5PnJ5XwrAeevoQZv9KI4pd8Om8Ecr6RMrB4QPEIWFH9bFKNn7IOW6XxTDElWe2hh-nMYjO9wUL2vAmU43jPygzAfBClT-3yg"
    
    
    #meta data 
    Connection = "keep-alive"
    Accept= "application/json, text/plain, */*"
    ContentType = "application/json; charset=utf-8"
    Host = "wabi-staging-us-east-redirect.analysis.windows.net"
    ContentLength =  230
    PostStringHead = "https://wabi-staging-us-east-redirect.analysis.windows.net/v1.0/myorg/groups/"
	#MSIT:  https://df-msit-scus-redirect.analysis.windows.net/v1.0/myorg/groups/%7bWorkspace_ID%7d/
    PostStringTail =  "/datapools/createReference"
	PostStringTemp =  "http://httpbin.org/post"
    
    

    #extra Data for debug 
    someIndex = 2
	someRemark = "any remark"
}

#user data may change 
if($rB.kustoQuery){ $Body.kustoQuery = $rB.kustoQuery}
if($rB.kustoCluster){ $Body.kustoCluster = $rB.kustoCluster}
if($rB.kustoDatabase){ $Body.kustoDatabase = $rB.kustoDatabase}

if($rB.containerName){ $Body.containerName = $rB.containerName}
if($rB.templateContainer){ $Body.templateContainer = $rB.templateContainer}
if($rB.datapoolName){ $Body.datapoolName = $rB.datapoolName}
if($rB.description){ $Body.description = $rB.description}
if($rB.subscriptionId){ $Body.subscriptionId = $rB.subscriptionId}
if($rB.tenantId){ $Body.tenantId = $rB.tenantId}
if($rB.secretPath){ $Body.secretPath = $rB.secretPath}
if($rB.workspaceID){ $Body.workspaceID = $rB.workspaceID}
if($rB.upn){ $Body.upn = $rB.upn}
if($rB.Authorization){ $Body.Authorization = $rB.Authorization}

if($rB.userQuerySelectionID){ $Body.userQuerySelectionID = $rB.userQuerySelectionID}
if($rB.userParam1){ $Body.userParam1 = $rB.userParam1}
if($rB.userParam2){ $Body.userParam2 = $rB.userParam2}


#for demo
if($rB.resourceGroupName){ $Body.resourceGroupName = $rB.resourceGroupName}
if($rB.storageName){ $Body.storageName = $rB.storageName}
if($rB.storagePrimeKey){ $Body.storagePrimeKey = $rB.storagePrimeKey}
if($rB.storageRootURL){ $Body.storageRootURL = $rB.storageRootURL}
if($rB.templateContainer){ $Body.templateContainer = $rB.templateContainer}
if($rB.ADappID){ $Body.ADappID = $rB.ADappID}
if($rB.tableMapResources){ $Body.tableMapResources = $rB.tableMapResources}
if($rB.ADappName){ $Body.ADappName = $rB.ADappName}


$outJson = ConvertTo-Json($Body)


Out-File -Encoding Ascii -FilePath $res -inputObject $outJson
