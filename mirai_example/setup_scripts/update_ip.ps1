param (
    [parameter(Mandatory = $true)]
    [string]$VmName,
    [parameter(Mandatory = $true)]
    [string]$NewIp
)

#if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64")
#{
#    write-warning "Y'arg Matey, we're off to 64-bit land....."
#    Write-Output "running with $NewIp"
#    &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.InvocationName -VmName $VmName -NewIp $NewIp
#    exit $lastexitcode
#}

try
{
    #    $ip=$(vagrant ssh $VmName -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")
    Write-Output $( [IntPtr]::size )
    Write-Output $( $Env:variablename )
    Write-Output ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)

    $path = $( Get-location | select-object -ExpandProperty path )
    $ip = $( get-vm -Name vm1 | select-object -ExpandProperty networkadapters | select-object -ExpandProperty ipaddresses | select-object -first 1 )
    #    Start-Job {
    ssh -o StrictHostKeyChecking = no -i $path/.vagrant/machines/$VmName/hyperv/private_key vagrant@$ip -p 22 "sudo ifconfig eth0 $NewIp netmask 255.255.255.0"
    #    } | Wait-Job -Timeout 3
    #    Add-VMNetworkAdapter -VMName $VMName -SwitchName "Default Switch" -Name HotAdded -DeviceNaming On
}
catch
{
    $message = $_
    Write-Host "Failed to run script: $message"
}