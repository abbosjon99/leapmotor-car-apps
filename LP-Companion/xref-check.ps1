# Cross-check for the smali project. Run after every change:  powershell -ExecutionPolicy Bypass -File xref-check.ps1 -Dir source\smali
param([string]$Dir)
# Cross-check: every method / field reference to a class of this app must resolve to a definition
# (the assembler does not check this; a mismatch is a NoSuchMethodError / NoSuchFieldError at runtime).
$files = Get-ChildItem -Path $Dir -Filter *.smali -Recurse
$methods = @{}   # "Class->name(desc)ret" -> $true
$fields  = @{}   # "Class->name:type" -> $true
$supers  = @{}   # class -> super
$ifaces  = @{}
foreach ($f in $files) {
  $cls = $null
  foreach ($line in Get-Content $f.FullName) {
    if ($line -cmatch '^\.class .*?(L[^;]+;)\s*$') { $cls = $Matches[1]; continue }
    if ($line -cmatch '^\.super (L[^;]+;)') { $supers[$cls] = $Matches[1]; continue }
    if ($line -cmatch '^\.method .*?([A-Za-z0-9_$<>]+\([^)]*\)\S+)\s*$') { $methods["$cls->$($Matches[1])"] = $true; continue }
    if ($line -cmatch '^\.field .*?([A-Za-z0-9_$]+):(\S+?)( =.*)?$') { $fields["$cls->$($Matches[1]):$($Matches[2])"] = $true; continue }
  }
}
function Resolve-Method($cls, $sig) {
  $c = $cls
  while ($c -and $supers.ContainsKey($c)) {
    if ($methods.ContainsKey("$c->$sig")) { return $true }
    $c = $supers[$c]
  }
  if ($methods.ContainsKey("$c->$sig")) { return $true }
  return $false
}
function Resolve-Field($cls, $sig) {
  $c = $cls
  while ($c -and $supers.ContainsKey($c)) {
    if ($fields.ContainsKey("$c->$sig")) { return $true }
    $c = $supers[$c]
  }
  return $fields.ContainsKey("$c->$sig")
}
$bad = 0
foreach ($f in $files) {
  $n = 0
  foreach ($line in Get-Content $f.FullName) {
    $n++
    if ($line -cmatch '^\s*invoke-\S+ .*?(Luz/carhelper/passenger/[A-Za-z0-9_$]+;)->([A-Za-z0-9_$<>]+\([^)]*\)\S+)') {
      $c = $Matches[1]; $s = $Matches[2]
      if (-not (Resolve-Method $c $s)) {
        # may be inherited from a framework class (super not in app): only report when the class is ours and has no non-app super hit
        $sup = $supers[$c]
        if ($sup -and $sup -like 'Luz/carhelper/*') { "$($f.Name):$n  missing method $c->$s" ; $bad++ }
        elseif ($s -like '<init>*' -or $c -eq 'Luz/carhelper/passenger/MainActivity;' -or $true) {
          # report anyway: framework-inherited methods are referenced through the framework class in this code base
          "$($f.Name):$n  unresolved $c->$s  (super: $sup)" ; $bad++
        }
      }
    }
    elseif ($line -cmatch '^\s*[is](get|put)\S* .*?(Luz/carhelper/passenger/[A-Za-z0-9_$]+;)->([A-Za-z0-9_$]+):(\S+)') {
      $c = $Matches[2]; $s = "$($Matches[3]):$($Matches[4])"
      if (-not (Resolve-Field $c $s)) { "$($f.Name):$n  missing field $c->$s" ; $bad++ }
    }
  }
}
"checked $($files.Count) files, $($methods.Count) methods, $($fields.Count) fields; problems: $bad"


