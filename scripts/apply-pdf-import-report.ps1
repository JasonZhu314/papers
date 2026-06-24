param(
  [Parameter(Mandatory = $true)]
  [string]$ReportCsv,
  [string]$ArchiveRoot = "_attachments\PDFs",
  [string]$AppliedReportDir = "_private\import-reports",
  [switch]$IncludeMedium,
  [switch]$MoveManualReview,
  [switch]$WhatIf
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

function New-Directory($path) {
  if (-not (Test-Path -LiteralPath $path)) {
    New-Item -ItemType Directory -Force -Path $path | Out-Null
  }
}

function Sanitize-FileName($name) {
  $invalid = [System.IO.Path]::GetInvalidFileNameChars()
  foreach ($ch in $invalid) { $name = $name.Replace($ch, ' ') }
  $name = ($name -replace '\s+', ' ').Trim()
  if ($name.Length -gt 180) { $name = $name.Substring(0, 180).Trim() }
  if (-not $name.ToLowerInvariant().EndsWith('.pdf')) { $name = $name + '.pdf' }
  return $name
}

function Join-CategoryPath($root, $category) {
  $parts = $category -split '[\\/]+' | Where-Object { $_ -and $_.Trim().Length -gt 0 }
  $path = $root
  foreach ($part in $parts) { $path = Join-Path $path $part }
  return $path
}

function Get-UniqueDestination($dir, $fileName) {
  $candidate = Join-Path $dir $fileName
  if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }
  $base = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
  $ext = [System.IO.Path]::GetExtension($fileName)
  for ($i = 2; $i -lt 1000; $i++) {
    $candidate = Join-Path $dir ("$base ($i)$ext")
    if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }
  }
  throw "Could not find unique destination for $fileName in $dir"
}

$reportPath = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $ReportCsv).Path)
$archiveFull = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $ArchiveRoot))
$archiveResolved = $archiveFull.TrimEnd('\') + '\'
New-Directory $archiveFull
New-Directory $AppliedReportDir

$rows = Import-Csv -LiteralPath $reportPath
$selected = foreach ($row in $rows) {
  $shouldMove = $false
  if ($row.document_type -eq 'research_paper' -and $row.confidence -eq 'high') { $shouldMove = $true }
  if ($row.document_type -eq 'research_paper' -and $row.confidence -eq 'medium' -and $IncludeMedium) { $shouldMove = $true }
  if ($row.document_type -eq 'manual_review' -and $MoveManualReview) { $shouldMove = $true }
  if ($shouldMove) { $row }
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$appliedCsv = Join-Path $AppliedReportDir "pdf-import-applied-$timestamp.csv"
$results = New-Object System.Collections.Generic.List[object]
$moved = 0
$missing = 0
$skipped = 0

foreach ($row in $selected) {
  $source = $row.source
  $status = 'skipped'
  $finalDest = ''
  $errorMessage = ''
  if (-not (Test-Path -LiteralPath $source)) {
    $status = 'missing_source'
    $missing++
  } else {
    $destDir = Join-CategoryPath $archiveFull $row.category
    $destDirFull = [System.IO.Path]::GetFullPath($destDir).TrimEnd('\') + '\'
    if (-not $destDirFull.StartsWith($archiveResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to move outside archive root: $destDirFull"
    }
    $fileName = Sanitize-FileName ([System.IO.Path]::GetFileName($source))
    $finalDest = Get-UniqueDestination $destDir $fileName
    if ($WhatIf) {
      $status = 'would_move'
      $skipped++
    } else {
      try {
        New-Directory $destDir
        Move-Item -LiteralPath $source -Destination $finalDest
        $status = 'moved'
        $moved++
      } catch {
        $status = 'error'
        $errorMessage = $_.Exception.Message
      }
    }
  }
  [void]$results.Add([pscustomobject]@{
    status = $status
    source = $source
    destination = $finalDest
    document_type = $row.document_type
    confidence = $row.confidence
    category = $row.category
    file_name = $row.file_name
    pages = $row.pages
    paper_score = $row.paper_score
    book_score = $row.book_score
    error = $errorMessage
  })
}

$results | Export-Csv -LiteralPath $appliedCsv -NoTypeInformation -Encoding UTF8
Write-Host "Selected: $(@($selected).Count)"
Write-Host "Moved: $moved"
Write-Host "Missing: $missing"
Write-Host "Skipped: $skipped"
Write-Host "Applied report: $appliedCsv"
$results | Group-Object status | Sort-Object Name | Select-Object Count,Name | Format-Table -AutoSize
