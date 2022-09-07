param(
    [parameter(Mandatory = $true)]
    [string]$VmName
)

. (${PSScriptRoot} + '\..\env.ps1')

try
{
    Write-Host "------------------ Configure Node with Powershell Script : $VmName -------------------"
    Write-Host "VM-Machine: $VmName"
    Write-Host "ContentRoot: $ContentRoot"

    $ip = $( get-vm -Name $VmName | select-object -ExpandProperty networkadapters | select-object -ExpandProperty ipaddresses | select-object -first 1 )

#    Write-Output y | pscp -i $ContentRoot/.vagrant/machines/$VmName/hyperv/private_key -r $ContentRoot/shared/xcompilers vagrant@${ip}:"~/xcompilers"

    scp -o StrictHostKeyChecking=no -i $ContentRoot/.vagrant/machines/$VmName/hyperv/private_key -r $ContentRoot/shared vagrant@${ip}:"~/shared"

#    ssh -o StrictHostKeyChecking = no -i $ContentRoot/.vagrant/machines/$VmName/hyperv/private_key vagrant@$ip -p 22 "sudo ifconfig eth0 $NewIp netmask 255.255.255.0"

}
catch
{
    $message = $_
    Write-Host "Failed to run script: $message"
}
