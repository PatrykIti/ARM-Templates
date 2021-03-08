$rg = 'dev01eun14cb4-st1'
New-AzureRmResourceGroup -Name $rg -Location northeurope -Force

New-AzureRmResourceGroupDeployment `
    -Name 'StorageAcc' `
    -ResourceGroupName $rg `
    -storageName 'devcontoso01' `
    -TemplateFile 'main.json'

Test-AzureRmResourceGroupDeployment -ResourceGroupName $rg -TemplateFile 'main.json'