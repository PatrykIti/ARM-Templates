$rg = "deveunsqltest01"
$ehn = Get-AzureRmResource -Name "*eventhubnamespace*"
$ehnAuthRule = (Get-AzureRmEventHubAuthorizationRule -ResourceGroupName $ehn.ResourceGroupName -Namespace $ehn.Name -Name "RootManageSharedAccessKey").id

New-AzureRmResourceGroup -Name $rg -Location northeurope

$date = get-date -Format yyyyMMdd-HHmmss
New-AzureRmResourceGroupDeployment -Name "new-sql-deploy-$date" -ResourceGroupName $rg -TemplateFile 'main.json' -serverName 'deveunsql01' -sqlDBName "SampleDB" -administratorLogin "azureadmin" -administratorLoginPassword "adminadmin123!" -eventHubName "eh-for-sql" -eventHubAuthKey $ehnAuthRule
