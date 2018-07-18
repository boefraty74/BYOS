

# POST method: $req
$requestBody = Get-Content $req -Raw | ConvertFrom-Json

#User / Installer data
$name = $requestBody.name
$newSecretName = $requestBody.newSecretName
$containerName = $requestBody.containerName
$upn = $requestBody.upn
$userTenantID = $requestBody.userTenantID

# ISV methadata 
$ISVtenantID = $requestBody.ISVtenantID
$azureAccountID = $requestBody.azureAccountID
$servicePrinciplePassword = $requestBody.servicePrinciplePassword
$vaultName = $requestBody.vaultName
$accountName = $requestBody.accountName
$accountKey =  $requestBody.accountKey



# create string for secret value 
$secretString = "temp"

$someString1 = '{ "'+'storageDetails'+'": { "containerName":"'+$containerName+'",'
$someString2 = ' "accountName": "'+$accountName+'", '
$someString3 = ' "accountKey": "'+$accountKey+'"  }, '
$someString4 = '"allowedPrincipals": [ { '
$someString5 = '"$type": "upn",   '
$someString6 = '"upn":'+'"'+$upn+'",   '
$someString7 = '"tenantId":'+'"'+$userTenantID+'"}]}   '

$secretString = $someString1 + $someString2 + $someString3 + $someString4 + $someString5 + $someString6 + $someString7


$azurePassword = ConvertTo-SecureString  $servicePrinciplePassword -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAccountID, $azurePassword)

#log in as ServicePrincipal
Add-AzureRmAccount -Credential $psCred -TenantId $ISVtenantID -ServicePrincipal

$secretvalue = ConvertTo-SecureString -String $secretString -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $vaultName -Name $newSecretName -SecretValue $secretvalue


Remove-AzureRmAccount

#output 
Out-File -Encoding Ascii -FilePath $res -inputObject "Done with $newSecretName and $secretString"
