$root = "C:\Users\306605\OneDrive - TenneT TSO B.V\GithubCopilotWS\utc_conv"
$changed = @()

Get-ChildItem -LiteralPath $root -File | ForEach-Object {
  $path = $_.FullName
  $lines = Get-Content -LiteralPath $path -Encoding UTF8
  $origText = $lines -join "`r`n"

  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -notmatch '(?i)sys_extract_utc\(systimestamp\)') { continue }

    $m = [regex]::Match($line, '^(?<indent>\s*)(?<left>.*?):=(?<rhs>.*?);\s*$')
    if (-not $m.Success) { continue }

    $indent = $m.Groups['indent'].Value
    $left = $m.Groups['left'].Value.TrimEnd()
    $rhs = $m.Groups['rhs'].Value
    $rhs = [regex]::Replace($rhs, '(?i)sys_extract_utc\(systimestamp\)', 'sys_extract_utc(systimestamp)')
    $rhs = $rhs.Trim()

    $targetPos = $null

    if ($i -gt 0 -and $lines[$i - 1] -match ':=') {
      $targetPos = $lines[$i - 1].IndexOf(':=') - ($lines[$i - 1].Length - $lines[$i - 1].TrimStart().Length)
    }

    if ($null -eq $targetPos -and $i + 1 -lt $lines.Count -and $lines[$i + 1] -match ':=') {
      $targetPos = $lines[$i + 1].IndexOf(':=') - ($lines[$i + 1].Length - $lines[$i + 1].TrimStart().Length)
    }

    if ($null -eq $targetPos -or $targetPos -lt 1) {
      $targetPos = $left.Length + 1
    }

    $pad = $targetPos - $left.Length
    if ($pad -lt 1) { $pad = 1 }

    $lines[$i] = "$indent$left$(' ' * $pad):= $rhs;"
  }

  $newText = $lines -join "`r`n"
  if ($newText -ne $origText) {
    [System.IO.File]::WriteAllText($path, $newText, [System.Text.UTF8Encoding]::new($false))
    $changed += $_.Name
  }
}

"changed_files_count: $($changed.Count)"
$changed | Sort-Object
