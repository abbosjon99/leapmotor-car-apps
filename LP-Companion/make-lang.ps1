# Builds source\assets\lang\*.tsv from translations.txt (english||uz||ru||es||zh per line).
# en.tsv only holds the two "OK" helper keys; every other English text is its own translation.
param([string]$Root = $PSScriptRoot)
$src = Join-Path $Root 'translations.txt'
$out = Join-Path $Root 'source\assets\lang'
New-Item -ItemType Directory -Force -Path $out | Out-Null
$langs = @('uz', 'ru', 'es', 'zh')
function Fit([string]$key, [string]$val) {
  # spaces at the start or end belong to the text (an editor may have dropped trailing ones): copy the key's
  $lead = $key.Substring(0, $key.Length - $key.TrimStart().Length)
  $trail = $key.Substring($key.TrimEnd().Length)
  return $lead + $val.Trim() + $trail
}
$rows = @{}
foreach ($l in $langs) { $rows[$l] = New-Object System.Collections.Generic.List[string] }
$en = New-Object System.Collections.Generic.List[string]
$n = 0; $bad = 0
foreach ($line in [System.IO.File]::ReadAllLines($src, [System.Text.Encoding]::UTF8)) {
  $n++
  if ($line.Length -eq 0 -or $line.StartsWith('#')) { continue }
  $f = $line.Split(@('||'), [System.StringSplitOptions]::None)
  if ($f.Count -ne 5) { "line ${n}: expected 5 fields, found $($f.Count): $line"; $bad++; continue }
  if ($line.Contains("`t")) { "line ${n}: contains a tab"; $bad++; continue }
  for ($i = 0; $i -lt 4; $i++) { $rows[$langs[$i]].Add($f[0] + "`t" + (Fit $f[0] $f[$i + 1])) }
  if ($f[0] -eq 'status OK' -or $f[0] -eq 'level OK') { $en.Add($f[0] + "`t" + 'OK') }
}
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($l in $langs) { [System.IO.File]::WriteAllText((Join-Path $out "$l.tsv"), (($rows[$l] -join "`n") + "`n"), $utf8) }
[System.IO.File]::WriteAllText((Join-Path $out 'en.tsv'), (($en -join "`n") + "`n"), $utf8)
"wrote $($rows['uz'].Count) strings x 4 languages (+ en.tsv with $($en.Count) helper keys); problems: $bad"
