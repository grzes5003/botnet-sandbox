
# load ContentRoot variable
. (${PSScriptRoot} + '\..\env.ps1')
Write-Host $ContentRoot
$base_url = 'https://www.uclibc.org/downloads/binaries/0.9.30.1'


Write-Host "Checking: ${args}"
Write-Host '--------=======-------'

Set-Location (${ContentRoot} + '/shared/xcompilers/')
$xcompilers_root = Get-ChildItem -Path (${ContentRoot} + '/shared/xcompilers/')


$missing = $args | Where-Object {!($_ + '.tar.bz2' -in $xcompilers_root.Name)}
if ($missing.Length -eq 0) {
    Write-Host 'All files already inplace'
    Write-Host '--------=======-------'
    exit 0
}
Write-Host "Missing: ${missing}"

Write-Host '--------Download missing files---------'

foreach ($file in $missing) {
    $url = ($base_url + '/' + $file + '.tar.bz2')
    Write-Host "Downloading ${url}"
    Invoke-WebRequest $url -OutFile "${file}.tar.bz2"
}

Write-Host '--------=======-------'
