param (
    [parameter(Mandatory = $true)]
    [string]$VmName,
    [parameter(Mandatory = $true)]
    [string]$SwitchName
)

try
{
    Write-Host "------------------ Configure Node with Powershell Script : $VmName -------------------"
    Write-Host "VM-Machine: $VmName"
    Write-Host "Add Switch: $SwitchName"
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    Write-Host "IsAdmin: " $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $vm = Hyper-V\Get-VM -Name $VmName -ErrorAction "stop"
    if (-Not (Get-VMNetworkAdapter $vm | Where-Object {$_.Name -eq "MiraiNic"}))
    {
        Hyper-V\Add-VMNetworkAdapter $vm -Switch $SwitchName -Name "MiraiNic"
    }
#    Get-VMNetworkAdapter $vm -Name "MiraiNic"
#    Set-VMNetworkAdapter -VMName $vm -VMNetworkAdapterName "MiraiNic" –PortMirroring Source
    Write-Host "------------------ Configuration of Node finished  -------------------"
}
catch
{
    $message = $_
    Write-Host "Failed to set VMs Second Nic: ${message}"
}