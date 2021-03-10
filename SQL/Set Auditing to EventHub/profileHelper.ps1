$rg = "deveunsqltest8"
New-AzureRmResourceGroup -Name $rg -Location northeurope

$date = get-date -Format yyyyMMdd-HHmmss
New-AzureRmResourceGroupDeployment -Name "new-sql-deploy-$date" -ResourceGroupName $rg -TemplateFile 'main.json' -serverName 'deveunsql08'
