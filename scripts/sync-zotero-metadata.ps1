param(
  [Parameter(Mandatory = $true)]
  [string]$BibFile,
  [string]$ReportDir = '_private\zotero',
  [switch]$Apply,
  [switch]$OverwriteBibliographicFields
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function New-Directory($path) {
  if (-not (Test-Path -LiteralPath $path)) {
    New-Item -ItemType Directory -Force -Path $path | Out-Null
  }
}

function Get-RelativePathLocal($root, $path) {
  $rootFull = [System.IO.Path]::GetFullPath($root).TrimEnd('\') + '\'
  $pathFull = [System.IO.Path]::GetFullPath($path)
  if ($pathFull.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $pathFull.Substring($rootFull.Length)
  }
  return $pathFull
}

function Escape-YamlDoubleQuoted($value) {
  if ($null -eq $value) { return '' }
  $escaped = [string]$value
  $escaped = $escaped.Replace('\', '\\')
  $escaped = $escaped.Replace('"', '\"')
  return $escaped
}

function Get-YamlScalar($value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return '' }
  return '"' + (Escape-YamlDoubleQuoted $value) + '"'
}

function Normalize-Whitespace($value) {
  if ($null -eq $value) { return '' }
  return (($value -replace '\s+', ' ').Trim())
}

function Remove-BibTexMarkup($value) {
  if ($null -eq $value) { return '' }
  $text = [string]$value
  $text = $text -replace '\\&', '&'
  $text = $text -replace '\\_', '_'
  $text = $text -replace '\\%', '%'
  $text = $text -replace '\\#', '#'
  $text = $text -replace '\\textendash\s*', '-'
  $text = $text -replace '\\textemdash\s*', '-'
  $text = $text -replace '\\[a-zA-Z]+\s*', ''
  $text = $text.Replace('{', '').Replace('}', '')
  return Normalize-Whitespace $text
}

function Normalize-Title($value) {
  $text = Remove-BibTexMarkup $value
  $text = $text.ToLowerInvariant()
  $text = $text -replace '[^a-z0-9]+', ' '
  return Normalize-Whitespace $text
}

function Normalize-Doi($value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return '' }
  $text = ([string]$value).Trim()
  $text = $text -replace '^(?i)https?://(dx\.)?doi\.org/', ''
  $text = $text.Trim().TrimEnd('.', ',', ';')
  return $text.ToLowerInvariant()
}

function Normalize-Arxiv($value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return '' }
  $text = ([string]$value).Trim()
  $text = $text -replace '^(?i)https?://arxiv\.org/(abs|pdf)/', ''
  $text = $text -replace '^(?i)arxiv\s*:\s*', ''
  $text = $text -replace '(?i)\.pdf$', ''
  $text = $text.Trim().TrimEnd('.', ',', ';')
  $text = $text -replace '(?i)v\d+$', ''
  return $text.ToLowerInvariant()
}

function Get-ArxivFromText($value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return '' }
  $text = [string]$value
  if ($text -match '(?i)arxiv\.org/(?:abs|pdf)/([a-z.-]+/\d{7}|\d{4}\.\d{4,5})(v\d+)?') {
    return ($Matches[1] + $Matches[2]).Trim()
  }
  if ($text -match '(?i)arxiv\s*:?\s*([a-z.-]+/\d{7}|\d{4}\.\d{4,5})(v\d+)?') {
    return ($Matches[1] + $Matches[2]).Trim()
  }
  return ''
}

function Get-CleanBibValue($value) {
  return Remove-BibTexMarkup $value
}

function Read-BibValue($text, [ref]$index) {
  $len = $text.Length
  while ($index.Value -lt $len -and [char]::IsWhiteSpace($text[$index.Value])) { $index.Value++ }
  if ($index.Value -ge $len) { return '' }
  $startChar = $text[$index.Value]
  if ($startChar -eq '{') {
    $index.Value++
    $start = $index.Value
    $depth = 1
    while ($index.Value -lt $len -and $depth -gt 0) {
      $ch = $text[$index.Value]
      if ($ch -eq '\') {
        $index.Value += 2
        continue
      }
      if ($ch -eq '{') { $depth++ }
      elseif ($ch -eq '}') { $depth-- }
      $index.Value++
    }
    $end = [Math]::Max($start, $index.Value - 1)
    return $text.Substring($start, $end - $start)
  }
  if ($startChar -eq '"') {
    $index.Value++
    $start = $index.Value
    while ($index.Value -lt $len) {
      $ch = $text[$index.Value]
      if ($ch -eq '\') {
        $index.Value += 2
        continue
      }
      if ($ch -eq '"') { break }
      $index.Value++
    }
    $end = $index.Value
    if ($index.Value -lt $len -and $text[$index.Value] -eq '"') { $index.Value++ }
    return $text.Substring($start, $end - $start)
  }
  $start = $index.Value
  while ($index.Value -lt $len -and $text[$index.Value] -ne ',') { $index.Value++ }
  return $text.Substring($start, $index.Value - $start).Trim()
}

function Parse-BibFields($body) {
  $fields = @{}
  $i = 0
  $len = $body.Length
  while ($i -lt $len) {
    while ($i -lt $len -and ([char]::IsWhiteSpace($body[$i]) -or $body[$i] -eq ',')) { $i++ }
    if ($i -ge $len) { break }
    $nameStart = $i
    while ($i -lt $len -and ($body[$i] -match '[A-Za-z0-9_:\-]')) { $i++ }
    if ($i -eq $nameStart) { $i++; continue }
    $name = $body.Substring($nameStart, $i - $nameStart).ToLowerInvariant()
    while ($i -lt $len -and [char]::IsWhiteSpace($body[$i])) { $i++ }
    if ($i -ge $len -or $body[$i] -ne '=') { continue }
    $i++
    $ref = [ref]$i
    $value = Read-BibValue $body $ref
    $i = $ref.Value
    $fields[$name] = Get-CleanBibValue $value
    while ($i -lt $len -and $body[$i] -ne ',') { $i++ }
    if ($i -lt $len -and $body[$i] -eq ',') { $i++ }
  }
  return $fields
}

function Parse-BibEntries($path) {
  $text = [System.IO.File]::ReadAllText($path)
  $entries = New-Object System.Collections.Generic.List[object]
  $i = 0
  while ($true) {
    $at = $text.IndexOf('@', $i)
    if ($at -lt 0) { break }
    $typeStart = $at + 1
    $open = $typeStart
    while ($open -lt $text.Length -and $text[$open] -ne '{' -and $text[$open] -ne '(') { $open++ }
    if ($open -ge $text.Length) { break }
    $entryType = $text.Substring($typeStart, $open - $typeStart).Trim().ToLowerInvariant()
    if ($entryType -in @('comment', 'preamble', 'string')) {
      $i = $open + 1
      continue
    }
    $closeChar = if ($text[$open] -eq '{') { '}' } else { ')' }
    $keyStart = $open + 1
    $comma = $keyStart
    while ($comma -lt $text.Length -and $text[$comma] -ne ',') { $comma++ }
    if ($comma -ge $text.Length) { break }
    $key = $text.Substring($keyStart, $comma - $keyStart).Trim()
    $bodyStart = $comma + 1
    $j = $bodyStart
    $depth = 1
    while ($j -lt $text.Length -and $depth -gt 0) {
      $ch = $text[$j]
      if ($ch -eq '\') {
        $j += 2
        continue
      }
      if ($ch -eq $text[$open]) { $depth++ }
      elseif ($ch -eq $closeChar) { $depth-- }
      $j++
    }
    if ($depth -ne 0) { break }
    $bodyEnd = $j - 1
    $body = $text.Substring($bodyStart, $bodyEnd - $bodyStart)
    $fields = Parse-BibFields $body
    [void]$entries.Add([pscustomobject]@{ Key = $key; Type = $entryType; Fields = $fields })
    $i = $j
  }
  return $entries
}

function Get-Field($entry, [string[]]$names) {
  foreach ($name in $names) {
    $key = $name.ToLowerInvariant()
    if ($entry.Fields.ContainsKey($key) -and -not [string]::IsNullOrWhiteSpace($entry.Fields[$key])) {
      return [string]$entry.Fields[$key]
    }
  }
  return ''
}

function Get-EntryMetadata($entry) {
  $title = Get-Field $entry @('title')
  $doi = Normalize-Doi (Get-Field $entry @('doi'))
  $url = Get-Field $entry @('url')
  $arxiv = ''
  $eprint = Get-Field $entry @('eprint')
  $archivePrefix = Get-Field $entry @('archiveprefix', 'archivePrefix')
  if ($eprint -and ($archivePrefix -match '(?i)arxiv' -or $url -match '(?i)arxiv' -or -not $archivePrefix)) {
    $arxiv = $eprint
  }
  if (-not $arxiv) { $arxiv = Get-ArxivFromText $url }
  if (-not $arxiv) { $arxiv = Get-ArxivFromText (Get-Field $entry @('note')) }
  $year = Get-Field $entry @('year')
  if (-not $year) {
    $date = Get-Field $entry @('date')
    if ($date -match '(\d{4})') { $year = $Matches[1] }
  }
  $venue = Get-Field $entry @('venue', 'booktitle', 'journaltitle', 'journal', 'eventtitle', 'publisher', 'school')
  $authorsText = Get-Field $entry @('author')
  $authors = @()
  if ($authorsText) {
    $authors = @($authorsText -split '\s+and\s+' | ForEach-Object { Normalize-Whitespace $_ } | Where-Object { $_ })
  }
  $zoteroKey = Get-Field $entry @('zotero-key', 'zotero_key', 'zoteroitemkey', 'zotero_item_key', 'itemkey', 'item_key')
  $zoteroUri = Get-Field $entry @('zotero-uri', 'zotero_uri', 'zoterouri', 'select')
  if (-not $zoteroUri -and $zoteroKey) { $zoteroUri = 'zotero://select/library/items/' + $zoteroKey }
  $zoteroPdfUri = Get-Field $entry @('zotero-pdf-uri', 'zotero_pdf_uri', 'zoteroattachmenturi', 'zotero_attachment_uri')
  return [pscustomobject]@{
    citation_key = $entry.Key
    title = $title
    title_norm = Normalize-Title $title
    authors = $authors
    year = $year
    venue = $venue
    doi = $doi
    arxiv = $arxiv
    arxiv_norm = Normalize-Arxiv $arxiv
    url = $url
    zotero_key = $zoteroKey
    zotero_uri = $zoteroUri
    zotero_pdf_uri = $zoteroPdfUri
  }
}

function Add-ToIndex($index, $key, $entry) {
  if ([string]::IsNullOrWhiteSpace($key)) { return }
  if (-not $index.ContainsKey($key)) { $index[$key] = New-Object System.Collections.Generic.List[object] }
  [void]$index[$key].Add($entry)
}

function Get-FrontmatterBounds($lines) {
  if ($lines.Count -lt 2 -or $lines[0] -ne '---') { return $null }
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -eq '---') { return [pscustomobject]@{ Start = 0; End = $i } }
  }
  return $null
}

function Unquote-YamlScalar($value) {
  if ($null -eq $value) { return '' }
  $text = ([string]$value).Trim()
  if ($text.Length -ge 2 -and $text.StartsWith('"') -and $text.EndsWith('"')) {
    $text = $text.Substring(1, $text.Length - 2)
    $text = $text.Replace('\"', '"').Replace('\\', '\')
  }
  return $text
}

function Get-FrontmatterScalar($lines, $bounds, $field) {
  for ($i = $bounds.Start + 1; $i -lt $bounds.End; $i++) {
    if ($lines[$i] -match ('^' + [regex]::Escape($field) + ':\s*(.*)$')) {
      return Unquote-YamlScalar $Matches[1]
    }
  }
  return ''
}

function Get-FieldLineIndex($lines, $bounds, $field) {
  for ($i = $bounds.Start + 1; $i -lt $bounds.End; $i++) {
    if ($lines[$i] -match ('^' + [regex]::Escape($field) + ':')) { return $i }
  }
  return -1
}

function Test-ScalarBlank($lines, $bounds, $field) {
  $idx = Get-FieldLineIndex $lines $bounds $field
  if ($idx -lt 0) { return $true }
  $value = Get-FrontmatterScalar $lines $bounds $field
  return [string]::IsNullOrWhiteSpace($value)
}

function Test-AuthorsBlank($lines, $bounds) {
  $idx = Get-FieldLineIndex $lines $bounds 'authors'
  if ($idx -lt 0) { return $true }
  if ($lines[$idx] -match '^authors:\s*\[\]\s*$') { return $true }
  if ($lines[$idx] -match '^authors:\s*$') {
    if ($idx + 1 -ge $bounds.End) { return $true }
    return -not ($lines[$idx + 1] -match '^\s*-\s+')
  }
  return [string]::IsNullOrWhiteSpace((Get-FrontmatterScalar $lines $bounds 'authors'))
}

function Get-InsertAfterField($field) {
  $after = @{
    authors = 'aliases'
    year = 'authors'
    venue = 'year'
    citation_key = 'tags'
    zotero_key = 'citation_key'
    zotero_uri = 'zotero_key'
    zotero_pdf_uri = 'zotero_uri'
    url = 'zotero_pdf_uri'
    doi = 'url'
    arxiv = 'doi'
  }
  if ($after.ContainsKey($field)) { return $after[$field] }
  return ''
}

function Insert-FieldLine($lines, [ref]$bounds, $field, [string[]]$newLines) {
  $after = Get-InsertAfterField $field
  $insertAt = $bounds.Value.End
  if ($after) {
    $afterIdx = Get-FieldLineIndex $lines $bounds.Value $after
    if ($afterIdx -ge 0) {
      $insertAt = $afterIdx + 1
      while ($insertAt -lt $bounds.Value.End -and $lines[$insertAt] -match '^\s+-\s+') { $insertAt++ }
    }
  }
  for ($i = $newLines.Count - 1; $i -ge 0; $i--) { $lines.Insert($insertAt, $newLines[$i]) }
  $bounds.Value = [pscustomobject]@{ Start = $bounds.Value.Start; End = $bounds.Value.End + $newLines.Count }
}

function Set-ScalarField($lines, [ref]$bounds, $field, $value) {
  $line = if ([string]::IsNullOrWhiteSpace($value)) { $field + ':' } else { $field + ': ' + (Get-YamlScalar $value) }
  $idx = Get-FieldLineIndex $lines $bounds.Value $field
  if ($idx -ge 0) {
    $lines[$idx] = $line
  } else {
    Insert-FieldLine $lines $bounds $field @($line)
  }
}

function Set-YearField($lines, [ref]$bounds, $value) {
  $line = if ([string]::IsNullOrWhiteSpace($value)) { 'year:' } else { 'year: ' + $value }
  $idx = Get-FieldLineIndex $lines $bounds.Value 'year'
  if ($idx -ge 0) { $lines[$idx] = $line } else { Insert-FieldLine $lines $bounds 'year' @($line) }
}

function Set-AuthorsField($lines, [ref]$bounds, [string[]]$authors) {
  $newLines = @()
  if ($authors.Count -eq 0) {
    $newLines = @('authors: []')
  } else {
    $newLines += 'authors:'
    foreach ($author in $authors) { $newLines += '  - ' + (Get-YamlScalar $author) }
  }
  $idx = Get-FieldLineIndex $lines $bounds.Value 'authors'
  if ($idx -ge 0) {
    $end = $idx + 1
    while ($end -lt $bounds.Value.End -and $lines[$end] -match '^\s+-\s+') { $end++ }
    $removeCount = $end - $idx
    $lines.RemoveRange($idx, $removeCount)
    for ($i = $newLines.Count - 1; $i -ge 0; $i--) { $lines.Insert($idx, $newLines[$i]) }
    $bounds.Value = [pscustomobject]@{ Start = $bounds.Value.Start; End = $bounds.Value.End - $removeCount + $newLines.Count }
  } else {
    Insert-FieldLine $lines $bounds 'authors' $newLines
  }
}

function Update-NoteMetadata($notePath, $metadata) {
  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.AddRange([string[]](Get-Content -LiteralPath $notePath -Encoding UTF8))
  $bounds = Get-FrontmatterBounds $lines
  if ($null -eq $bounds) { return [pscustomobject]@{ Changed = $false; Fields = @(); Content = $null; Reason = 'no frontmatter' } }
  $boundsRef = [ref]$bounds
  $changed = New-Object System.Collections.Generic.List[string]

  if ($metadata.authors.Count -gt 0 -and ($OverwriteBibliographicFields -or (Test-AuthorsBlank $lines $boundsRef.Value))) {
    Set-AuthorsField $lines $boundsRef ([string[]]$metadata.authors)
    [void]$changed.Add('authors')
  }
  if ($metadata.year -and ($OverwriteBibliographicFields -or (Test-ScalarBlank $lines $boundsRef.Value 'year'))) {
    Set-YearField $lines $boundsRef $metadata.year
    [void]$changed.Add('year')
  }
  foreach ($field in @('venue', 'citation_key', 'zotero_key', 'zotero_uri', 'zotero_pdf_uri', 'url', 'doi', 'arxiv')) {
    $value = $metadata.$field
    if ($value -and ($OverwriteBibliographicFields -or (Test-ScalarBlank $lines $boundsRef.Value $field))) {
      Set-ScalarField $lines $boundsRef $field $value
      [void]$changed.Add($field)
    }
  }

  if ($changed.Count -eq 0) { return [pscustomobject]@{ Changed = $false; Fields = @(); Content = $null; Reason = 'no blank bibliographic fields' } }
  return [pscustomobject]@{ Changed = $true; Fields = @($changed); Content = ($lines -join "`r`n") + "`r`n"; Reason = '' }
}

function Get-PaperNotes($root) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.md' | Where-Object {
    $_.FullName -notmatch '\\(_private|_templates|_dashboards|_catalog)\\'
  }
  $notes = New-Object System.Collections.Generic.List[object]
  foreach ($file in $files) {
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    if ($text -notmatch '(?m)^note_type:\s*paper\s*$') { continue }
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.AddRange([string[]]($text -split "`r?`n"))
    $bounds = Get-FrontmatterBounds $lines
    if ($null -eq $bounds) { continue }
    $title = Get-FrontmatterScalar $lines $bounds 'title'
    [void]$notes.Add([pscustomobject]@{
      Path = $file.FullName
      Rel = Get-RelativePathLocal $root $file.FullName
      Title = $title
      TitleNorm = Normalize-Title $title
      Doi = Normalize-Doi (Get-FrontmatterScalar $lines $bounds 'doi')
      Arxiv = Normalize-Arxiv (Get-FrontmatterScalar $lines $bounds 'arxiv')
      CitationKey = Get-FrontmatterScalar $lines $bounds 'citation_key'
    })
  }
  return $notes
}

$root = (Resolve-Path -LiteralPath '.').Path
$bibFull = [System.IO.Path]::GetFullPath((Join-Path $root $BibFile))
if (-not (Test-Path -LiteralPath $bibFull)) { throw "BibTeX export not found: $bibFull" }

$reportFull = [System.IO.Path]::GetFullPath((Join-Path $root $ReportDir))
New-Directory $reportFull
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportCsv = Join-Path $reportFull "zotero-sync-$timestamp.csv"

$entries = Parse-BibEntries $bibFull | ForEach-Object { Get-EntryMetadata $_ }
$doiIndex = @{}
$arxivIndex = @{}
$titleIndex = @{}
foreach ($entry in $entries) {
  Add-ToIndex $doiIndex $entry.doi $entry
  Add-ToIndex $arxivIndex $entry.arxiv_norm $entry
  Add-ToIndex $titleIndex $entry.title_norm $entry
}

$notes = Get-PaperNotes $root
$rows = New-Object System.Collections.Generic.List[object]
$matched = 0
$changedCount = 0
$ambiguous = 0
$unmatched = 0

foreach ($note in $notes) {
  $candidates = @()
  $matchBy = ''
  if ($note.Doi -and $doiIndex.ContainsKey($note.Doi)) {
    $candidates = @($doiIndex[$note.Doi].ToArray())
    $matchBy = 'doi'
  } elseif ($note.Arxiv -and $arxivIndex.ContainsKey($note.Arxiv)) {
    $candidates = @($arxivIndex[$note.Arxiv].ToArray())
    $matchBy = 'arxiv'
  } elseif ($note.TitleNorm -and $titleIndex.ContainsKey($note.TitleNorm)) {
    $candidates = @($titleIndex[$note.TitleNorm].ToArray())
    $matchBy = 'title'
  }

  if ($candidates.Count -eq 0) {
    $unmatched++
    [void]$rows.Add([pscustomobject]@{ action = 'unmatched'; note = $note.Rel; match_by = ''; citation_key = $note.CitationKey; fields = ''; reason = 'no DOI/arXiv/title match in export' })
    continue
  }
  if ($candidates.Count -gt 1) {
    $ambiguous++
    $keys = ($candidates | ForEach-Object { $_.citation_key }) -join ';'
    [void]$rows.Add([pscustomobject]@{ action = 'ambiguous'; note = $note.Rel; match_by = $matchBy; citation_key = $keys; fields = ''; reason = 'multiple export entries matched' })
    continue
  }

  $matched++
  $entry = $candidates[0]
  $result = Update-NoteMetadata $note.Path $entry
  if ($result.Changed) {
    $changedCount++
    if ($Apply) { [System.IO.File]::WriteAllText($note.Path, [string]$result.Content, [System.Text.UTF8Encoding]::new($false)) }
    $action = if ($Apply) { 'updated' } else { 'would_update' }
    [void]$rows.Add([pscustomobject]@{ action = $action; note = $note.Rel; match_by = $matchBy; citation_key = $entry.citation_key; fields = ($result.Fields -join ';'); reason = '' })
  } else {
    [void]$rows.Add([pscustomobject]@{ action = 'no_change'; note = $note.Rel; match_by = $matchBy; citation_key = $entry.citation_key; fields = ''; reason = $result.Reason })
  }
}

$rows | Export-Csv -LiteralPath $reportCsv -NoTypeInformation -Encoding UTF8

Write-Host "Bib entries: $(@($entries).Count)"
Write-Host "Paper notes: $(@($notes).Count)"
Write-Host "Matched: $matched"
Write-Host "Would update / updated: $changedCount"
Write-Host "Ambiguous: $ambiguous"
Write-Host "Unmatched: $unmatched"
Write-Host "Report: $reportCsv"
if (-not $Apply) { Write-Host 'Dry run only. Re-run with -Apply to update notes.' }