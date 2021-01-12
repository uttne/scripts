Param([string] $Path = "", [switch] $Force = $FALSE)

$TargetDir = Convert-Path .

if($Path){
    $TargetDir = $Path
}

$ScriptPath = $MyInvocation.MyCommand.Path

$Dirs = Get-ChildItem -Path $TargetDir -Force -Filter * | Where-Object { $_.PSIsContainer }
$Files = Get-ChildItem -Path $TargetDir -Force -File -Filter * | Where-Object { $_.FullName -ne $ScriptPath }

if( -not $($Dirs -is [array])){
    $Dirs = @($Dirs)
}

if( -not $($Files -is [array])){
    $Files = @($Files)
}

if($($Dirs.Length + $Files.Length) -eq 0){
    exit
}

if($Dirs.Length -ne 0){
    Write-Output "Target dirs:"
}

foreach($dir in $Dirs) {
    Write-Output "    $($dir.FullName)"
}

if($Files.Length -ne 0){
    Write-Output "Target files:"
}
foreach($file in $Files) {
    Write-Output "    $($file.FullName)"
}

$Input = "y"

if( -not $Force ){
    $Input = Read-Host "Delete targets, right? ([y]es/[n]o)"
}


if($Input -eq "y" -or $Input -eq "yes"){
    foreach($file in $Files) {
        Remove-Item -Path $file.FullName -Force -Verbose
    }
    foreach($dir in $Dirs) {
        Remove-Item -Path $dir.FullName -Force -Recurse -Verbose
    }
}
else {
    Write-Output "No delete."
}
