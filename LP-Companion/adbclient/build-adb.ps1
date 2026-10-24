# Rebuilds source\smali\uz\carhelper\passenger\adb\*.smali (the adb client), ...\apk\*.smali (the file manager UI) and
# ...\boot\*.smali (the start-after-restart loop) from the Java in adbclient\src.
#   1. javac (Java 8 level): adb client, then the UI against android.jar plus the compile stubs in adbclient\stubs
#   2. tests of the adb client against a mock adbd (must pass)
#   3. D8 -> classes.dex (stubs are only on the classpath, never converted)
#   4. apktool turns the dex into smali, copied into the app project
# Needs tools\r8.jar (Google's D8 8.5.35, https://dl.google.com/dl/android/maven2/com/android/tools/r8/8.5.35/r8-8.5.35.jar,
# SHA-1 6b41e4ac5e238c953246d07c006585aecc16c546), tools\android.jar (from Google's platform-31_r01.zip, SHA-1
# ca5bcaa565cb37e9d287051d6dd0e49a5426ec29), tools\apktool.jar and the JDK in tools\jdk.
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$root = Split-Path $here -Parent
$jdk = Join-Path $root 'tools\jdk\bin'
$android = Join-Path $root 'tools\android.jar'
$out = Join-Path $here 'out'
Remove-Item -Recurse -Force $out -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "$out\main", "$out\ui", "$out\test", "$out\dex", "$out\pkg" | Out-Null

# 1a. the adb client (plain Java, no Android classes)
$adbSources = Get-ChildItem "$here\src\uz\carhelper\passenger\adb" -Filter *.java | ForEach-Object { $_.FullName }
& "$jdk\javac.exe" --release 8 -Xlint:-options -d "$out\main" $adbSources
if ($LASTEXITCODE -ne 0) { throw 'javac (adb) failed' }

# 1b. the UI, checked against the real Android API
$uiSources = @(Get-ChildItem "$here\src\uz\carhelper\passenger\apk" -Filter *.java | ForEach-Object { $_.FullName })
$uiSources += Get-ChildItem "$here\src\uz\carhelper\passenger\boot" -Filter *.java | ForEach-Object { $_.FullName }
$uiSources += Get-ChildItem "$here\stubs" -Recurse -Filter *.java | ForEach-Object { $_.FullName }
& "$jdk\javac.exe" --release 8 -Xlint:-options -cp "$android;$out\main" -d "$out\ui" $uiSources
if ($LASTEXITCODE -ne 0) { throw 'javac (ui) failed' }

# 2. tests
$tests = Get-ChildItem "$here\test" -Filter *.java | ForEach-Object { $_.FullName }
& "$jdk\javac.exe" -Xlint:-options -cp "$out\main" -d "$out\test" $tests
if ($LASTEXITCODE -ne 0) { throw 'javac (tests) failed' }
& "$jdk\java.exe" -cp "$out\main;$out\test" AdbTests
if ($LASTEXITCODE -ne 0) { throw 'tests failed - not converting' }

# 3. D8: the adb client, the apk UI classes and the boot starter only (the stubs Ui / Lang / Backup / BackRepair /
#    Swapper / BubbleService / MainBubbleService stay out)
$classes = @(Get-ChildItem "$out\main" -Recurse -Filter *.class | ForEach-Object { $_.FullName })
$classes += Get-ChildItem "$out\ui\uz\carhelper\passenger\apk" -Filter *.class | ForEach-Object { $_.FullName }
$classes += Get-ChildItem "$out\ui\uz\carhelper\passenger\boot" -Filter *.class | ForEach-Object { $_.FullName }
& "$jdk\java.exe" -cp "$root\tools\r8.jar" com.android.tools.r8.D8 --release --min-api 26 --lib $android --classpath "$out\ui" --classpath "$out\main" --output "$out\dex" $classes
if ($LASTEXITCODE -ne 0) { throw 'D8 failed' }

# 4. apktool only needs an apk to decode: classes.dex + any manifest
Copy-Item "$out\dex\classes.dex" "$out\pkg\classes.dex"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$apk = "$out\adbonly.apk"
$manifestApk = Join-Path $root 'LP-Companion.apk'
$tmp = "$out\pkg\AndroidManifest.xml"
$zip = [System.IO.Compression.ZipFile]::OpenRead($manifestApk)
try { $e = $zip.GetEntry('AndroidManifest.xml'); [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e, $tmp, $true) } finally { $zip.Dispose() }
[System.IO.Compression.ZipFile]::CreateFromDirectory("$out\pkg", $apk)
& "$jdk\java.exe" -jar "$root\tools\apktool.jar" d -r -f -o "$out\decoded" $apk
if ($LASTEXITCODE -ne 0) { throw 'apktool failed' }

foreach ($pkg in 'adb', 'apk', 'boot') {
    $dest = Join-Path $root "source\smali\uz\carhelper\passenger\$pkg"
    Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item "$out\decoded\smali\uz\carhelper\passenger\$pkg\*.smali" $dest -Force
    "done: $((Get-ChildItem $dest -Filter *.smali).Count) smali files in $dest"
}
