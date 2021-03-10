$rg = "deveunsqltest2"
New-AzureRmResourceGroup -Name $rg -Location northeurope

$date = get-date -Format yyyyMMdd-HHmm
New-AzureRmResourceGroupDeployment -Name "new-sql-deploy-$date" -ResourceGroupName $rg -TemplateFile 'main.json' -serverName 'deveunsql03'

Test-AzureRmResourceGroupDeployment -ResourceGroupName $rg -TemplateFile 'main.json' -serverName 'deveunsql03'
