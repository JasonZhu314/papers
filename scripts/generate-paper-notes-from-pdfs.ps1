param(
  [string]$ArchiveRoot = '_attachments\PDFs',
  [string]$ReportDir = '_private\note-generation-reports',
  [int]$TextPages = 2,
  [int]$Limit = 0,
  [switch]$Apply,
  [switch]$Overwrite,
  [string]$DefaultStatus = 'library',
  [int]$DefaultImportance = 1
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function Resolve-Tool($name) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $cmd) { return $null }
  return $cmd.Source
}

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

function Convert-ToVaultPath($path) {
  return ($path -replace '\\', '/')
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

function Get-YamlList($values) {
  $items = @($values | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  if ($items.Count -eq 0) { return '[]' }
  $lines = New-Object System.Collections.Generic.List[string]
  foreach ($item in $items) {
    [void]$lines.Add('  - "' + (Escape-YamlDoubleQuoted $item) + '"')
  }
  return ($lines -join "`r`n")
}

function Get-TitleFromFileName($fileName) {
  $title = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
  $title = ($title -replace '\s+', ' ').Trim()
  return $title
}

function Get-ArxivYear($arxivId) {
  if ([string]::IsNullOrWhiteSpace($arxivId)) { return '' }
  if ($arxivId -match '^(\d{2})(\d{2})\.\d{4,5}') {
    $yy = [int]$Matches[1]
    if ($yy -ge 7 -and $yy -le 99) { return (2000 + $yy).ToString() }
  }
  return ''
}

function Get-CleanDoi($text) {
  if ([string]::IsNullOrWhiteSpace($text)) { return '' }
  if ($text -match '(?i)\b(10\.\d{4,9}/[-._;()/:A-Z0-9]+)') {
    return $Matches[1].TrimEnd('.', ',', ';', ':', ')', ']')
  }
  return ''
}

function Get-CleanArxiv($text) {
  if ([string]::IsNullOrWhiteSpace($text)) { return '' }
  if ($text -match '(?i)arxiv(?:\s*preprint)?\s*:?\s*([a-z.-]+/\d{7}|\d{4}\.\d{4,5})(v\d+)?') {
    return ($Matches[1] + $Matches[2]).Trim()
  }
  if ($text -match '(?i)arxiv\.org/(?:abs|pdf)/([a-z.-]+/\d{7}|\d{4}\.\d{4,5})(v\d+)?') {
    return ($Matches[1] + $Matches[2]).Trim()
  }
  return ''
}

function Invoke-PdfInfoSafe($tool, $path) {
  $result = [ordered]@{ title = ''; author = ''; pages = ''; raw = '' }
  if (-not $tool) { return [pscustomobject]$result }
  $oldErrorActionPreference = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $raw = & $tool $path 2>$null | Out-String
    $result.raw = $raw
    if ($raw -match '(?m)^Title:[ \t]*(.+)$') { $result.title = $Matches[1].Trim() }
    if ($raw -match '(?m)^Author:[ \t]*(.+)$') { $result.author = $Matches[1].Trim() }
    if ($raw -match '(?m)^Pages:[ \t]*(\d+)') { $result.pages = $Matches[1].Trim() }
  } catch {
    $result.raw = ''
  } finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }
  return [pscustomobject]$result
}

function Invoke-PdfTextSafe($tool, $path, $pages) {
  if (-not $tool) { return '' }
  $oldErrorActionPreference = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $text = & $tool -q -f 1 -l ([Math]::Max(1, $pages)) -enc UTF-8 $path - 2>$null | Out-String
    if ($text.Length -gt 20000) { return $text.Substring(0, 20000) }
    return $text
  } catch {
    return ''
  } finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }
}

function Get-LocalMetadata($pdf, $pdfInfoTool, $pdfTextTool, $textPages) {
  $info = Invoke-PdfInfoSafe $pdfInfoTool $pdf.FullName
  $text = Invoke-PdfTextSafe $pdfTextTool $pdf.FullName $textPages
  $haystack = [string]::Join("`n", @($pdf.Name, $info.raw, $text))
  $arxiv = Get-CleanArxiv $haystack
  $doi = Get-CleanDoi $haystack
  $year = Get-ArxivYear $arxiv
  $url = ''
  if ($arxiv) { $url = 'https://arxiv.org/abs/' + ($arxiv -replace 'v\d+$', '') }
  return [pscustomobject]@{
    arxiv = $arxiv
    doi = $doi
    year = $year
    url = $url
    pdfinfo_title = $info.title
    pdfinfo_author = $info.author
    pages = $info.pages
    text_extracted = -not [string]::IsNullOrWhiteSpace($text)
  }
}

function New-PaperNoteContent($title, $topics, $pdfVaultPath, $metadata, $dateAdded, $defaultStatus, $defaultImportance) {
  $pdfLink = '[[' + $pdfVaultPath + '|Open PDF]]'
  $topicItems = @($topics | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  if ($topicItems.Count -eq 0) {
    $topicLines = @('topics: []')
  } else {
    $topicLines = @('topics:', (Get-YamlList $topicItems))
  }
  $yearLine = if ($metadata.year) { 'year: ' + $metadata.year } else { 'year:' }
  $urlLine = if ($metadata.url) { 'url: ' + (Get-YamlScalar $metadata.url) } else { 'url:' }
  $doiLine = if ($metadata.doi) { 'doi: ' + (Get-YamlScalar $metadata.doi) } else { 'doi:' }
  $arxivLine = if ($metadata.arxiv) { 'arxiv: ' + (Get-YamlScalar $metadata.arxiv) } else { 'arxiv:' }
  $frontmatterBeforeTopics = @(
    '---',
    'note_type: paper',
    ('title: {0}' -f (Get-YamlScalar $title)),
    'aliases: []',
    'authors: []',
    $yearLine,
    'venue:',
    'paper_type: research',
    ('status: {0}' -f $defaultStatus),
    'depth: skim',
    ('importance: {0}' -f $defaultImportance)
  )
  $frontmatterAfterTopics = @(
    'tags: []',
    'citation_key:',
    'zotero_key:',
    'zotero_uri:',
    'zotero_pdf_uri:',
    $urlLine,
    $doiLine,
    $arxivLine,
    ('pdf: {0}' -f (Get-YamlScalar $pdfVaultPath)),
    ('date_added: {0}' -f $dateAdded),
    'date_read:',
    'has_ideas: false',
    'publish: true',
    '---',
    '',
    ('# {0}' -f $title),
    '',
    ('PDF: {0}' -f $pdfLink),
    '',
    '## Quick Recall',
    '',
    '-',
    '',
    '## Why Read',
    '',
    '-',
    '',
    '## Problem And Motivation',
    '',
    '-',
    '',
    '## Core Idea',
    '',
    '-',
    '',
    '## Method At A Glance',
    '',
    '-',
    '',
    '## Experiments And Evaluation',
    '',
    '-',
    '',
    '## Theory Or Formal Result',
    '',
    '-',
    '',
    '## Related Work Map',
    '',
    '- Predecessors:',
    '- Contemporary work:',
    '- Follow-ups:',
    '',
    '## Limitations',
    '',
    '-',
    '',
    '## Connections And Ideas',
    '',
    '-',
    '',
    '## Follow-Up',
    '',
    '- [ ] If reading this week, add this note to `_dashboards/This Week.md` and set the intended depth.',
    ''
  )
  $content = $frontmatterBeforeTopics + $topicLines + $frontmatterAfterTopics
  return ($content -join "`r`n")
}
$root = (Resolve-Path -LiteralPath '.').Path
$archiveFull = [System.IO.Path]::GetFullPath((Join-Path $root $ArchiveRoot))
$reportFull = [System.IO.Path]::GetFullPath((Join-Path $root $ReportDir))
$allowedStatuses = @('library', 'inbox', 'queued', 'reading', 'done', 'archived')
if ($DefaultStatus -notin $allowedStatuses) { throw "DefaultStatus must be one of: $($allowedStatuses -join ', ')" }
if ($DefaultImportance -lt 1 -or $DefaultImportance -gt 5) { throw 'DefaultImportance must be between 1 and 5.' }
New-Directory $reportFull

if (-not (Test-Path -LiteralPath $archiveFull)) {
  throw "Archive root does not exist: $archiveFull"
}

$pdfInfoTool = Resolve-Tool 'pdfinfo'
$pdfTextTool = Resolve-Tool 'pdftotext'
$dateAdded = Get-Date -Format 'yyyy-MM-dd'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportCsv = Join-Path $reportFull "paper-note-generation-$timestamp.csv"
$metadataCsv = Join-Path $reportFull "paper-note-metadata-$timestamp.csv"

$pdfs = Get-ChildItem -LiteralPath $archiveFull -Recurse -File -Filter '*.pdf' | Sort-Object FullName
if ($Limit -gt 0) { $pdfs = $pdfs | Select-Object -First $Limit }
$total = @($pdfs).Count
Write-Host "Processing $total PDFs from $archiveFull"

$archivePrefix = $archiveFull.TrimEnd('\') + '\'
$rows = New-Object System.Collections.Generic.List[object]
$metadataRows = New-Object System.Collections.Generic.List[object]
$created = 0
$skipped = 0
$updated = 0
$index = 0

foreach ($pdf in $pdfs) {
  $index++
  if (($index % 50) -eq 0) { Write-Host "Processed $index / $total" }
  $relativePdfFromArchive = $pdf.FullName.Substring($archivePrefix.Length)
  $relativePdfVault = Convert-ToVaultPath (Join-Path $ArchiveRoot $relativePdfFromArchive)
  $category = Split-Path -Parent $relativePdfFromArchive
  if ($null -eq $category) { $category = '' }
  $topics = @()
  if (-not [string]::IsNullOrWhiteSpace($category)) {
    $topics = @($category -split '\\' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  }
  $noteDir = if ([string]::IsNullOrWhiteSpace($category)) { $root } else { Join-Path $root $category }
  $noteName = [System.IO.Path]::GetFileNameWithoutExtension($pdf.Name) + '.md'
  $notePath = Join-Path $noteDir $noteName
  $relativeNote = Get-RelativePathLocal $root $notePath
  $title = Get-TitleFromFileName $pdf.Name
  $metadata = Get-LocalMetadata $pdf $pdfInfoTool $pdfTextTool $TextPages
  $action = 'would_create'
  $reason = ''
  if (Test-Path -LiteralPath $notePath) {
    if ($Overwrite) {
      $action = 'would_overwrite'
    } else {
      $action = 'skip_existing'
      $reason = 'note already exists'
      $skipped++
    }
  }

  if ($Apply -and ($action -eq 'would_create' -or $action -eq 'would_overwrite')) {
    New-Directory $noteDir
    $content = New-PaperNoteContent $title $topics $relativePdfVault $metadata $dateAdded $DefaultStatus $DefaultImportance
    [System.IO.File]::WriteAllText($notePath, [string]$content, [System.Text.UTF8Encoding]::new($false))
    if ($action -eq 'would_overwrite') {
      $updated++
      $action = 'overwritten'
    } else {
      $created++
      $action = 'created'
    }
  }

  [void]$rows.Add([pscustomobject]@{
    action = $action
    note = $relativeNote
    pdf = $relativePdfVault
    title = $title
    topics = ($topics -join ';')
    arxiv = $metadata.arxiv
    doi = $metadata.doi
    year = $metadata.year
    url = $metadata.url
    reason = $reason
  })
  [void]$metadataRows.Add([pscustomobject]@{
    note = $relativeNote
    pdf = $relativePdfVault
    title = $title
    arxiv = $metadata.arxiv
    doi = $metadata.doi
    year = $metadata.year
    url = $metadata.url
    pdfinfo_title = $metadata.pdfinfo_title
    pdfinfo_author = $metadata.pdfinfo_author
    pages = $metadata.pages
    text_extracted = $metadata.text_extracted
  })
}

$rows | Export-Csv -LiteralPath $reportCsv -NoTypeInformation -Encoding UTF8
$metadataRows | Export-Csv -LiteralPath $metadataCsv -NoTypeInformation -Encoding UTF8
Write-Host "Report: $reportCsv"
Write-Host "Metadata: $metadataCsv"
if ($Apply) {
  Write-Host "Created: $created"
  Write-Host "Overwritten: $updated"
  Write-Host "Skipped: $skipped"
} else {
  $wouldCreate = @($rows | Where-Object { $_.action -eq 'would_create' }).Count
  $wouldOverwrite = @($rows | Where-Object { $_.action -eq 'would_overwrite' }).Count
  $skipExisting = @($rows | Where-Object { $_.action -eq 'skip_existing' }).Count
  Write-Host "Would create: $wouldCreate"
  Write-Host "Would overwrite: $wouldOverwrite"
  Write-Host "Skip existing: $skipExisting"
}
