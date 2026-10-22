# Build + sign LP Companion from this folder.
# Run from inside LP-Companion-project:  powershell -ExecutionPolicy Bypass -File build.ps1
$ErrorActionPreference = "Stop"
$root  = $PSScriptRoot
$java  = Join-Path $root "tools\jdk\bin\java.exe"
$apk   = Join-Path $root "tools\apktool.jar"
$signer= Join-Path $root "tools\signer.jar"
$ks    = Join-Path $root "tools\signing-key.jks"
$k     = Get-Content (Join-Path $root "tools\signing-key.txt") | ConvertFrom-StringData
$src   = Join-Path $root "source"
$out   = Join-Path $root "build"

if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Force $out | Out-Null

# 1. build
& $java -jar $apk b -f -o "$out\unsigned.apk" $src
if (-not (Test-Path "$out\unsigned.apk")) { throw "apktool build failed" }

# 2. sign
& $java -jar $signer -a "$out\unsigned.apk" -o "$out\signed" `
    --ks $ks --ksAlias $k.alias --ksPass $k.password --ksKeyPass $k.password
$final = Get-ChildItem "$out\signed\*.apk" | Select-Object -First 1
Copy-Item $final.FullName "$root\LP-Companion.apk" -Force
Write-Host "Done -> $root\LP-Companion.apk"

# 3. (optional) install over wifi adb. Uncomment and set adb path:
# & "C:\path\to\adb.exe" install --no-incremental --install-reason 64 -r "$root\LP-Companion.apk"
