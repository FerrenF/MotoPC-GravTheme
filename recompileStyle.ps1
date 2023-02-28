
$root = Split-Path ($MyInvocation.MyCommand.Path) -Parent
$target = "css-compiled\global.css"
$source = "scss\global.scss"
echo "CWD: $root"

$val = Read-Host -Prompt "Enter 1 to recompile, 2 to watch"
if($val -eq 1) {
    $testSourcePath=$root+"\"+$target
    $testSourceFile=Split-Path $testSourcePath -Leaf
    $testSource=Test-Path ($testSourcePath)
 
    if ($testSource -eq $true) {
       if((Test-Path ($testSourcePath+".bak")) -eq $true) { Remove-Item $testSourcePath".bak" }
       Rename-Item -Path $testSourcePath -NewName $testSourceFile".bak" 
    }
    echo Recompiling scss...
    sass $source $target   
    if ($testSource -eq $true) {
        echo "success"
 
    } else {
        echo "failure, restoring..."
        Rename-Item -Path $testSourcePath".bak" -NewName $testSourceFile 
    }
} elseif($val -eq 2) {
    sass --watch $source $target
}
$cacheLocation = $root+"\..\..\..\cache\";
if( (Test-Path $cacheLocation) -eq $true ) {
    echo "purging $cacheLocation"
    Remove-Item $cacheLocation"\*" -Recurse
}
