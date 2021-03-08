$rg = 'dev01eun14cb4-sta'
New-AzureRmResourceGroup -Name $rg -Location northeurope -Force

New-AzureRmResourceGroupDeployment `
    -Name 'New-StorageAccount' `
    -ResourceGroupName $rg `
    -TemplateFile 'main.json'

Test-AzureRmResourceGroupDeployment -ResourceGroupName $rg -TemplateFile 'main.json'