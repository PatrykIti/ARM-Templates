$rg = 'arm-intro-01'
New-AzureRmResourceGroup -Name $rg -Location westeurope -Force

New-AzureRmResourceGroupDeployment `
    -Name 'New-Storage' `
    -ResourceGroupName $rg `
    -TemplateFile '01-storage.json' `
    -storageName 'statestpc03' `
    -storageSKU 'Standard_GRS'