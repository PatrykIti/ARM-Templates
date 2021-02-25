function Get-SubscriptionAzure{
   $Subscription = ((Get-AzureRmContext).subscription).subscriptionId
   return $Subscription
}
function Get-SubscriptionInfix{
    param(
        [string] $subscriptionId
    )
    $subscriptionId.substring(0,5)
}

function Get-LocationAcronym{
    param (
        [string]  $location
    )
    $allLocations = Get-AzureRmLocation

    if($location -in $allLocations.Location -or $location -in $allLocations.displayName){
        $temp = ($allLocations|?{ $_.location -eq $location -or $_.DisplayName -eq $location}).displayName
        $acronym = ($temp.Split(' ')).ToLower()

        if($acronym -eq 'europe'){
            $locationAcronym = 'eu'
        }elseif($acronym -eq 'brazil'){
            $locationAcronym = 'br'
        }else {
            $exc = [System.Exception]::new("Error")
            throw $exc
            Exit 0
        }

        if($acronym -eq 'west'){
            $locationAcronym += 'w'
        }elseif($acronym -eq 'east'){
            $locationAcronym += 'e'

        }elseif($acronym -eq 'north'){
            $locationAcronym += 'n'

        }elseif($acronym -eq 'south'){
            $locationAcronym += 's'
        }else {
            $exc = [System.Exception]::new("Error")
            throw $exc
            Exit 0
        }
        return $locationAcronym
  }
}
function New-ResourceGroup{

    param(
        [string] $environmentName,
        [string] $location,
        [string] $subscriptionInfix,
        [string] $solutioName
    )

    $rgName = "$($environment)$($subscriptionInfix)$($subscriptionInfix)-$($solutioName)"
    return New-AzureRmResourceGroup -Name $rgName -Location $location -Force
}

function New-AzureDataBricksCluster{
    param(
        [string] $deploymentName,
        [string] $resourceGroupName,
        [string] $templateFile
    )
    New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFile
}

$rgName = (New-ResourceGroup -environmentName 'dev' -location 'northeurope' -subscriptionInfix (Get-SubscriptionInfix -subscriptionId (Get-SubscriptionAzure)) -solutioName 'in')
New-AzureDataBricksCluster -deploymentName 'Databricks-24-02-2020' -resourceGroupName $rgName.resourceGroupName -templateFile 'main.json'

$testVnet = Get-AzureRmVirtualNetwork -Name 'deveun94db5-test2-vn' -ResourceGroupName 'deveun94db5-test2' -ErrorAction SilentlyContinue
$dbVnet = Get-AzureRmVirtualNetwork -Name 'workers-vnet' -ResourceGroupName 'deveun94db5-br-mgmt' -ErrorAction "SilentlyContinue"

if($null -eq $dbVnet){
    if($null -eq $testVnet){
        $exc = [System.Exception]::new("Brak sieci Testowej do peerowania")
        throw $exc
    }
    $exc = [System.Exception]::new("Brak sieci Databricks do peerowania")
    throw $exc
}
else
{
    Add-AzureRmVirtualNetworkPeering -Name 'vNetDevEun94db5Test_to_vNetDevEun94db5_br' -VirtualNetwork $testVnet -RemoteVirtualNetworkId $dbVnet.Id -ErrorVariable $errorVNetPeering -ErrorAction "SilentlyContinue"

    if($errorVnetPeering)
    {
        write-host 'Nie mozna utworzyc peeringu z powodu nakladania sie adresacji'
    }
    else
    {
        write-host 'Peering wykonany poprawnie'
    }
}