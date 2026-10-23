# Build + sign LP Music from this folder with LP Companion's toolchain (JDK, apktool, signer, key).
# Run:  powershell -ExecutionPolicy Bypass -File build.ps1 [-Tools <path-to-tools-folder>]
param([string]$Tools)
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $Tools) {
    $candidates = @(
        (Join-Path $root "..\LP-Companion\tools"),
        "C:\Users\user\Downloads\LP-Companion\tools"
    )
    $Tools = $candidates | Where-Object { Test-Path (Join-Path $_ "apktool.jar") } | Select-Object -First 1
}
if (-not $Tools) { throw "tools folder not found; pass -Tools <folder with jdk, apktool.jar, signer.jar, signing-key.*>" }
$java   = Join-Path $Tools "jdk\bin\java.exe"
$apk    = Join-Path $Tools "apktool.jar"
$signer = Join-Path $Tools "signer.jar"
$ks     = Join-Path $Tools "signing-key.jks"
$k      = Get-Content (Join-Path $Tools "signing-key.txt") | ConvertFrom-StringData
$src    = Join-Path $root "source"
$out    = Join-Path $root "build"

if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Force $out | Out-Null

# 1. build
& $java -jar $apk b -f -o "$out\unsigned.apk" $src
if (-not (Test-Path "$out\unsigned.apk")) { throw "apktool build failed" }

# 2. sign
& $java -jar $signer -a "$out\unsigned.apk" -o "$out\signed" `
    --ks $ks --ksAlias $k.alias --ksPass $k.password --ksKeyPass $k.password
$final = Get-ChildItem "$out\signed\*.apk" | Where-Object { $_.Name -notmatch "unsigned-aligned\.apk$" } | Select-Object -First 1
if (-not $final) { throw "signing failed" }
Copy-Item $final.FullName "$root\LP-Music.apk" -Force
$ver = (Get-Content (Join-Path $src "apktool.yml") | Select-String "versionName: '(.+)'").Matches[0].Groups[1].Value
Copy-Item $final.FullName "$root\LP-Music-$ver.apk" -Force
Write-Host "Done -> $root\LP-Music.apk (v$ver)"
