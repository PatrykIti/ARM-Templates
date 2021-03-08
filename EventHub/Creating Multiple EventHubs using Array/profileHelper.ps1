$rg = 'dev01eun14cb4-pl1'
New-AzureRmResourceGroup -Name $rg -Location northeurope -Force

New-AzureRmResourceGroupDeployment `
    -Name 'New-EventHub' `
    -ResourceGroupName $rg `
    -TemplateFile 'main.json'