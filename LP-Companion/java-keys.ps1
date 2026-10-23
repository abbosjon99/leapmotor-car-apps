# Lists the texts the Java UI asks Lang for (T("...") calls and the permission names in ApkInfo) that have no line in
# translations.txt. Run after changing adbclient\src\...\apk\*.java.
param([string]$Root = $PSScriptRoot)
function Unescape([string]$s) {
  $s = [regex]::Replace($s, '\\u([0-9a-fA-F]{4})', { param($m) [string][char][Convert]::ToInt32($m.Groups[1].Value, 16) })
  return $s.Replace('\n', "`n").Replace('\"', '"').Replace("\'", "'").Replace('\\', '\')
}
$have = @{}
foreach ($line in [System.IO.File]::ReadAllLines((Join-Path $Root 'translations.txt'), [System.Text.Encoding]::UTF8)) {
  if ($line.Length -eq 0 -or $line.StartsWith('#')) { continue }
  $have[$line.Split(@('||'), [System.StringSplitOptions]::None)[0]] = $true
}
$need = @{}
foreach ($f in Get-ChildItem (Join-Path $Root 'adbclient\src\uz\carhelper\passenger\apk') -Filter *.java) {
  $text = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
  foreach ($m in [regex]::Matches($text, '\bT\("((?:[^"\\]|\\.)*)"\)')) { $need[(Unescape $m.Groups[1].Value)] = $f.Name }
  if ($f.Name -eq 'ApkInfo.java') {
    foreach ($m in [regex]::Matches($text, '\{"android\.permission\.[A-Z_]+", "([^"]+)"\}')) { $need[$m.Groups[1].Value] = 'ApkInfo.java (permission name)' }
  }
}
$missing = $need.GetEnumerator() | Where-Object { -not $have.ContainsKey($_.Key) } | Sort-Object Value
"{0} texts used, {1} missing from translations.txt" -f $need.Count, @($missing).Count
$missing | ForEach-Object { "  [{0}]  ({1})" -f $_.Key, $_.Value }
