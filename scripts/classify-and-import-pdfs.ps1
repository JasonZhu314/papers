param(
  [string]$SourceDir = "C:\Users\zhuji\Documents\Books",
  [string]$ArchiveRoot = "_attachments\PDFs",
  [string]$ReportDir = "_private\import-reports",
  [int]$TextPages = 3,
  [int]$Limit = 0,
  [switch]$Apply,
  [switch]$IncludeMedium,
  [switch]$MoveManualReview
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Continue"

function Resolve-Tool($name) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $cmd) { throw "Required tool '$name' was not found on PATH." }
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

function Invoke-PdfInfo($tool, $path) {
  $output = & $tool $path 2>$null | Out-String
  $pages = $null
  $encrypted = $null
  if ($output -match '(?m)^Pages:\s+(\d+)') { $pages = [int]$Matches[1] }
  if ($output -match '(?m)^Encrypted:\s+(\S+)') { $encrypted = $Matches[1] }
  return [pscustomobject]@{ Pages = $pages; Encrypted = $encrypted; Raw = $output }
}

function Invoke-PdfText($tool, $path, $pages) {
  $lastPage = [Math]::Max(1, $pages)
  $output = & $tool -q -f 1 -l $lastPage -enc UTF-8 $path - 2>$null | Out-String
  if ($output.Length -gt 16000) { $output = $output.Substring(0, 16000) }
  return $output
}

function Add-RuleScore($haystack, $rules, [ref]$score, $reasons, $prefix) {
  foreach ($rule in $rules) {
    if ($haystack -match $rule.Regex) {
      $score.Value += [int]$rule.Weight
      [void]$reasons.Add("${prefix}:$($rule.Name)")
    }
  }
}

function Get-ResearchCategory($titleText, $bodyText) {
  $t = $titleText.ToLowerInvariant()
  $h = ($titleText + "`n" + $bodyText).ToLowerInvariant()

  # Very specific title-level signals should win over broad body-text signals.
  if ($t -match 'cap theorem|distributed systems') { return 'Computer Science\Distributed Systems' }
  if ($t -match 'cryptography|security') { return 'Computer Science\Security and Cryptography' }
  if ($t -match 'programming language|compiler') { return 'Computer Science\Programming Languages' }
  if ($t -match 'database|b-tree|b\+tree') { return 'Computer Science\Databases' }
  if ($t -match 'algorithm|complexity') { return 'Computer Science\Algorithms and Complexity' }

  if ($t -match 'adamw?|\bsgd\b|optimizer|optimizers|shampoo|\blion\b|\bmuon\b|sophia|gradient clipping|weight decay|learning rate|warmup|8-bit optimizer|zeroth-order optimization') {
    if ($h -match 'deep learning|neural network|language model|transformer|large model|training|machine learning') { return 'Foundations\Optimization for Deep Learning' }
  }

  if ($h -match 'alphageometry|alpha geometry|autoformalization|auto-formalization|theorem proving|formal proof|interactive theorem prover|proof assistant|lean theorem|conjecture generation|mathematical discovery|ai-assisted mathematical|use of ai in mathematical research') { return 'AI for Science\AI for Mathematics' }
  if ($h -match 'alphafold|protein structure|protein folding|genomics|drug discovery|biomedical|medicine|medical science|biology') { return 'AI for Science\Biology and Medicine' }
  if ($h -match 'molecular force field|force fields?|molecular generation|reaction prediction|catalyst|chemistry|chemical|materials discovery|materials science|self-driving laboratory') { return 'AI for Science\Chemistry and Materials' }
  if ($h -match 'weather|climate|earth system|geoscience|earth science') { return 'AI for Science\Climate and Earth Systems' }
  if ($h -match 'scientific foundation model|foundation model.*scientific|foundation model.*science|science foundation model') { return 'AI for Science\Scientific Foundation Models' }
  if ($h -match 'ai feynman|scientific discovery|ai for science|ai scientist|scientific agent|autonomous lab|closed-loop lab|robot scientist') { return 'AI for Science\Scientific Agents and Labs' }
  if ($h -match '(machine learning|deep learning|neural network|artificial intelligence|\bai\b).*(physics|physical discovery)|(physics|physical discovery).*(machine learning|deep learning|neural network|artificial intelligence|\bai\b)') { return 'AI for Science\Physics' }
  if ($h -match '(machine learning|deep learning|neural network|artificial intelligence|\bai\b).*(engineering design|engineering system)|(engineering design|engineering system).*(machine learning|deep learning|neural network|artificial intelligence|\bai\b)') { return 'AI for Science\Engineering Systems' }

  if ($h -match 'sparse autoencoder|\bsaes?\b|feature dictionary|dictionary learning.*feature') { return 'Mechanistic Interpretability\Sparse Autoencoders' }
  if ($h -match 'activation patching|path patching|causal tracing|causal intervention|causal scrubbing') { return 'Mechanistic Interpretability\Activation Patching and Causal Tracing' }
  if ($h -match 'mechanistic interpretability|induction heads?|superposition|circuits?|feature geometry') { return 'Mechanistic Interpretability\Circuits and Features' }
  if ($h -match 'representation geometry|linear representation|representation engineering|probing|linear probe') { return 'Mechanistic Interpretability\Representation Geometry' }
  if ($h -match 'ai safety|alignment|jailbreak|deceptive alignment|scalable oversight|red teaming|constitutional ai|model organism|mesa-optimization|privacy|fairness|bias') { return 'Mechanistic Interpretability\Alignment and Safety' }
  if ($h -match 'robustness|monitoring|anomaly detection|distribution shift|out-of-distribution|\bood\b') { return 'Mechanistic Interpretability\Robustness and Monitoring' }
  if ($h -match 'interpretability|explainable ai|\bxai\b|axiomatic attribution|integrated gradients|saliency|attribution method') { return 'Mechanistic Interpretability\Model Internals and Probing' }

  if ($h -match 'fourier neural operator|\bfno\b') { return 'SciML\Operator Learning\Neural Operators\Fourier Neural Operators' }
  if ($h -match 'graph neural operator|\bgno\b') { return 'SciML\Operator Learning\Neural Operators\Graph Neural Operators' }
  if ($h -match 'transformer neural operator') { return 'SciML\Operator Learning\Neural Operators\Transformer Neural Operators' }
  if ($h -match 'deeponet|deep operator network') { return 'SciML\Operator Learning\DeepONet' }
  if ($h -match 'neural operator|operator learning|learn(ing)? operators') { return 'SciML\Operator Learning\Neural Operators' }
  if ($h -match 'physics-informed|\bpinns?\b') { return 'SciML\Physics-Informed Learning\PINNs' }
  if ($h -match 'deep ritz|ritz method|energy minimization') { return 'SciML\Physics-Informed Learning\Variational and Energy Methods\Deep Ritz' }
  if ($h -match 'neural ode|neural ordinary differential') { return 'SciML\Neural Differential Equations\Neural ODEs' }
  if ($h -match 'neural sde|stochastic differential equation') { return 'SciML\Neural Differential Equations\Neural SDEs' }
  if ($h -match 'scientific machine learning|pde surrogate|surrogate model.*pde|learning-based multiscale|learned pde solver|data-driven.*pde') { return 'SciML\PDE Solvers and Surrogates' }

  if ($h -match 'large language model|\bllm\b|language models?|transformer|tokenizer|pretrain|pre-training|instruction tuning|rlhf|rlaif|direct preference optimization|\bdpo\b|rag|retrieval augmented|long context') {
    if ($h -match 'rlhf|rlaif|preference optimization|reward model|instruction tuning|supervised fine-tuning|\bsft\b|direct preference optimization|\bdpo\b') { return 'LLMs\Post-training' }
    if ($h -match 'inference|serving|kv cache|quantization|speculative decoding|decoding') { return 'LLMs\Inference' }
    if ($h -match 'retrieval|rag|memory') { return 'LLMs\Retrieval and Memory' }
    if ($h -match 'reasoning|agent|tool use|long context|multimodal') { return 'LLMs\Capabilities' }
    return 'LLMs\Pretraining'
  }

  if ($h -match 'diffusion model|score matching|score-based|flow matching|consistency model|latent diffusion') { return 'Generative AI\Diffusion and Score Models' }
  if ($h -match 'generative adversarial|\bgan\b|\bgans\b') { return 'Generative AI\GANs' }
  if ($h -match 'variational autoencoder|\bvae\b|normalizing flow') { return 'Generative AI\VAEs and Flow Models' }
  if ($h -match 'autoregressive generation|image generation|video generation|multimodal generation') { return 'Generative AI' }

  if ($h -match 'computer vision|image classification|object detection|segmentation|denoising|super-resolution|image restoration|vision transformer|\bvit\b|convolutional neural|\bcnn\b|optical flow|video understanding') {
    if ($h -match 'object detection|faster r-cnn|yolo|ssd') { return 'Computer Vision\Object Detection' }
    if ($h -match 'segmentation|mask r-cnn') { return 'Computer Vision\Segmentation' }
    if ($h -match 'denoising|super-resolution|restoration|low-level vision') { return 'Computer Vision\Low-Level Vision' }
    if ($h -match 'vision transformer|\bvit\b') { return 'Computer Vision\Architectures\Vision Transformers' }
    if ($h -match 'convolutional neural|\bcnn\b') { return 'Computer Vision\Architectures\CNNs' }
    return 'Computer Vision'
  }

  if ($h -match 'graph neural network|geometric deep learning|manifold learning|graph convolution|molecular graph') { return 'Graph and Geometric Learning' }
  if ($h -match 'reinforcement learning|policy optimization|markov decision|\bmdp\b|q-learning') { return 'Reinforcement Learning and Control' }
  if ($h -match 'distributed training|model compression|hardware|compiler|data systems|efficient inference') { return 'ML Systems' }

  if ($h -match 'optimal transport') { return 'Mathematics\Optimization\Optimal Transport' }
  if ($h -match 'convex optimization|nonconvex optimization|gradient descent|first-order method|second-order method|stochastic optimization|variational inequality|primal-dual|convergence rate|lower bound') { return 'Mathematics\Optimization' }
  if ($h -match 'numerical linear algebra|krylov|gmres|conjugate gradient|precondition(er|ing)|iterative solver|eigenvalue|singular linear systems?|semidefinite linear systems?|matrix factorization|qr factorization|lu factorization|low-rank|randomized linear algebra') { return 'Mathematics\Numerical Linear Algebra' }
  if ($h -match 'multigrid|finite element|finite difference|spectral method|numerical pde|approximation theory|error estimate|stability analysis') { return 'Mathematics\Numerical Analysis' }
  if ($h -match 'elliptic|parabolic|partial differential equations|calculus of variations|pde\b|\bodes?\b|ordinary differential equation|dynamical system|optimal control|control theory|stability theory') { return 'Mathematics\Differential Equations' }
  if ($h -match 'sobolev|functional analysis|banach|hilbert|spectral theory|measure theory|harmonic analysis|real analysis') { return 'Mathematics\Analysis' }
  if ($h -match 'probability|stochastic process|random matrix|high-dimensional probability|statistical inference|bayesian|monte carlo') { return 'Mathematics\Probability and Statistics' }
  if ($h -match 'algebraic geometry|differential geometry|riemannian geometry|topological data analysis|\btda\b|topology|manifold') { return 'Mathematics\Geometry' }
  if ($h -match 'abstract algebra|number theory|commutative algebra|representation theory|galois|torsion') { return 'Mathematics\Algebra' }
  if ($h -match 'combinatorics|graph theory|theoretical computer science|complexity theory|forcing|logic|set theory|proof theory|type theory|formalization|formal methods') { return 'Mathematics\TCS' }

  if ($h -match 'quantum|statistical mechanics|condensed matter|particle physics|relativity|gravitation|fluid dynamics|computational physics') {
    if ($h -match 'quantum') { return 'Physics\Quantum Physics' }
    if ($h -match 'statistical mechanics') { return 'Physics\Statistical Mechanics' }
    if ($h -match 'fluid dynamics') { return 'Physics\Fluid Dynamics' }
    if ($h -match 'relativity|gravitation') { return 'Physics\Relativity and Gravitation' }
    return 'Physics'
  }

  if ($h -match 'cap theorem|distributed systems|database|cryptography|programming language|compiler|software engineering|algorithm|complexity') {
    if ($h -match 'distributed systems|cap theorem') { return 'Computer Science\Distributed Systems' }
    if ($h -match 'cryptography|security') { return 'Computer Science\Security and Cryptography' }
    if ($h -match 'programming language|compiler') { return 'Computer Science\Programming Languages' }
    if ($h -match 'database') { return 'Computer Science\Databases' }
    if ($h -match 'algorithm|complexity') { return 'Computer Science\Algorithms and Complexity' }
    return 'Computer Science'
  }

  if ($h -match 'machine learning|deep learning|neural network|representation learning|generalization|memorization') { return 'Foundations' }

  return 'Unsorted Research'
}
function Classify-One($file, $sourceRoot, $archiveRoot, $pdfInfoTool, $pdfTextTool, $textPages) {
  $info = $null
  $text = ''
  $infoError = ''
  $textError = ''
  try { $info = Invoke-PdfInfo $pdfInfoTool $file.FullName } catch { $infoError = $_.Exception.Message }
  $pages = $null
  if ($info) { $pages = $info.Pages }
  $pagesToRead = $textPages
  if ($pages -and $pages -lt $pagesToRead) { $pagesToRead = $pages }
  try { $text = Invoke-PdfText $pdfTextTool $file.FullName $pagesToRead } catch { $textError = $_.Exception.Message }

  $title = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $haystack = ($title + "`n" + $text).ToLowerInvariant()
  $reasons = New-Object System.Collections.Generic.List[string]
  $paperScore = 0
  $bookScore = 0

  $paperRules = @(
    @{ Name = 'abstract'; Weight = 3; Regex = '\babstract\b' },
    @{ Name = 'arxiv'; Weight = 5; Regex = 'arxiv:\d{4}\.\d{4,5}|arxiv\.org|arxiv preprint' },
    @{ Name = 'conference'; Weight = 4; Regex = 'published as a conference paper|proceedings of|conference on|accepted at|submitted to' },
    @{ Name = 'venue'; Weight = 3; Regex = 'neurips|\bnips\b|icml|iclr|cvpr|eccv|iccv|aaai|ijcai|acl|emnlp|naacl|siggraph|kdd|\bwww\b|osdi|sosp|nsdi|sigcomm|stoc|focs|soda|lics|popl|pldi|sigmod|vldb|cav|icra|iros|rss' },
    @{ Name = 'journal'; Weight = 2; Regex = '\bieee\b|\bacm\b|\bsiam\b|journal of|transactions on|physical review|annals of|communications in|numerische mathematik|foundations of computational mathematics' },
    @{ Name = 'doi'; Weight = 2; Regex = '\bdoi\b|10\.\d{4,9}/' },
    @{ Name = 'keywords'; Weight = 1; Regex = '\bkeywords?\b' },
    @{ Name = 'references'; Weight = 2; Regex = '\breferences\b' }
  )
  $bookRules = @(
    @{ Name = 'isbn'; Weight = 5; Regex = '\bisbn\b' },
    @{ Name = 'contents'; Weight = 3; Regex = 'table of contents|\bcontents\b' },
    @{ Name = 'preface'; Weight = 3; Regex = '\bpreface\b|foreword' },
    @{ Name = 'chapter'; Weight = 3; Regex = 'chapter\s+1|chapter\s+one' },
    @{ Name = 'textbook-series'; Weight = 4; Regex = 'graduate texts in mathematics|undergraduate texts|lecture notes in mathematics|texts in applied mathematics' },
    @{ Name = 'edition'; Weight = 3; Regex = 'second edition|third edition|fourth edition|revised edition' },
    @{ Name = 'book-publisher'; Weight = 2; Regex = 'cambridge university press|oxford university press|springer-verlag|springer science|crc press|wiley|elsevier|mit press|princeton university press' },
    @{ Name = 'book-title'; Weight = 2; Regex = '\btextbook\b|\bhandbook\b|\bcourse in\b|\bintroduction to\b|\bguide to\b|\bprimer on\b|\btutorial\b|problem book' }
  )

  Add-RuleScore $haystack $paperRules ([ref]$paperScore) $reasons 'paper'
  Add-RuleScore $haystack $bookRules ([ref]$bookScore) $reasons 'book'

  $nonPaperTitleRegex = 'check\s*list|cheatsheet|cheat sheet|quick guide|practical guide|guide to|beginner''s guide|tutorial|lecture notes?|notes from|course in|textbook|interviews?|backup|digest|overview|whitepaper|report|trends report|roadmap|thesis|graduate school|postdoc|how to (write|give|do|succeed)|research talk|worldly wisdom|life in|mathematician''s (apology|lament)|upon the deep'
  if ($title.ToLowerInvariant() -match $nonPaperTitleRegex) {
    $bookScore += 8
    [void]$reasons.Add('manual:academic-adjacent-title')
  }
  if ($pages) {
    if ($pages -le 35) { $paperScore += 4; [void]$reasons.Add('paper:short-page-count') }
    elseif ($pages -le 80) { $paperScore += 2; [void]$reasons.Add('paper:moderate-page-count') }
    elseif ($pages -le 120) { $paperScore += 1; [void]$reasons.Add('paper:long-paper-page-count') }
    elseif ($pages -gt 250) { $bookScore += 7; [void]$reasons.Add('book:very-long-page-count') }
    elseif ($pages -gt 120) { $bookScore += 4; [void]$reasons.Add('book:long-page-count') }
  }

  if ($info -and $info.Encrypted -and $info.Encrypted -ne 'no') {
    $bookScore += 2
    [void]$reasons.Add('manual:encrypted')
  }
  if (-not $text -or $text.Trim().Length -lt 80) {
    [void]$reasons.Add('manual:little-text-extracted')
  }

  $docType = 'non_paper'
  $confidence = 'low'
  if ($paperScore -ge 10 -and $bookScore -le 5 -and ((-not $pages) -or $pages -le 120 -or $paperScore -ge 15)) {
    $docType = 'research_paper'
    $confidence = 'high'
  } elseif ($paperScore -ge 8 -and $bookScore -le 7 -and ((-not $pages) -or $pages -le 120)) {
    $docType = 'research_paper'
    $confidence = 'medium'
  } elseif ($paperScore -ge 5 -and $bookScore -le 9) {
    $docType = 'manual_review'
    $confidence = 'low'
  } elseif ($paperScore -ge 8 -and $bookScore -gt 7) {
    $docType = 'manual_review'
    $confidence = 'low'
  }

  $category = Get-ResearchCategory $title $text
  $destDir = Join-CategoryPath $archiveRoot $category
  $destPath = Join-Path $destDir (Sanitize-FileName $file.Name)

  return [pscustomobject]@{
    document_type = $docType
    confidence = $confidence
    category = $category
    source = $file.FullName
    relative_source = Get-RelativePathLocal $sourceRoot $file.FullName
    destination = $destPath
    file_name = $file.Name
    pages = $pages
    bytes = $file.Length
    paper_score = $paperScore
    book_score = $bookScore
    reasons = ($reasons -join ';')
    info_error = $infoError
    text_error = $textError
    moved = $false
    final_destination = ''
  }
}

$sourceFull = [System.IO.Path]::GetFullPath($SourceDir)
$archiveFull = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $ArchiveRoot))
$reportFull = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $ReportDir))
New-Directory $reportFull
New-Directory $archiveFull

$pdfInfoTool = Resolve-Tool 'pdfinfo'
$pdfTextTool = Resolve-Tool 'pdftotext'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportCsv = Join-Path $reportFull "pdf-classification-$timestamp.csv"
$reportJson = Join-Path $reportFull "pdf-classification-summary-$timestamp.json"

$files = Get-ChildItem -LiteralPath $sourceFull -Recurse -File -Filter '*.pdf' -ErrorAction SilentlyContinue | Sort-Object FullName
if ($Limit -gt 0) { $files = $files | Select-Object -First $Limit }
$total = @($files).Count
Write-Host "Classifying $total PDF files from $sourceFull"

$rows = New-Object System.Collections.Generic.List[object]
$index = 0
foreach ($file in $files) {
  $index++
  if (($index % 50) -eq 0) { Write-Host "Processed $index / $total" }
  $row = Classify-One $file $sourceFull $archiveFull $pdfInfoTool $pdfTextTool $TextPages
  [void]$rows.Add($row)
}

if ($Apply) {
  $archiveResolved = [System.IO.Path]::GetFullPath($archiveFull).TrimEnd('\') + '\'
  foreach ($row in $rows) {
    $shouldMove = $false
    if ($row.document_type -eq 'research_paper' -and $row.confidence -eq 'high') { $shouldMove = $true }
    if ($row.document_type -eq 'research_paper' -and $row.confidence -eq 'medium' -and $IncludeMedium) { $shouldMove = $true }
    if ($row.document_type -eq 'manual_review' -and $MoveManualReview) { $shouldMove = $true }
    if (-not $shouldMove) { continue }

    $destDir = Split-Path -Parent $row.destination
    New-Directory $destDir
    $destDirFull = [System.IO.Path]::GetFullPath($destDir).TrimEnd('\') + '\'
    if (-not $destDirFull.StartsWith($archiveResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to move outside archive root: $destDirFull"
    }
    $fileName = [System.IO.Path]::GetFileName($row.destination)
    $finalDest = Get-UniqueDestination $destDir $fileName
    Move-Item -LiteralPath $row.source -Destination $finalDest
    $row.moved = $true
    $row.final_destination = $finalDest
  }
}

$rows | Export-Csv -LiteralPath $reportCsv -NoTypeInformation -Encoding UTF8
$summary = [pscustomobject]@{
  source = $sourceFull
  archive = $archiveFull
  report_csv = $reportCsv
  apply = [bool]$Apply
  include_medium = [bool]$IncludeMedium
  total = $rows.Count
  by_document_type = @($rows | Group-Object document_type | Sort-Object Name | ForEach-Object { [pscustomobject]@{ name = $_.Name; count = $_.Count } })
  by_confidence = @($rows | Group-Object confidence | Sort-Object Name | ForEach-Object { [pscustomobject]@{ name = $_.Name; count = $_.Count } })
  by_category = @($rows | Group-Object category | Sort-Object Count -Descending | ForEach-Object { [pscustomobject]@{ name = $_.Name; count = $_.Count } })
  moved = @($rows | Where-Object { $_.moved }).Count
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportJson -Encoding UTF8
Write-Host "Report: $reportCsv"
Write-Host "Summary: $reportJson"
Write-Host "Moved: $($summary.moved)"
$summary.by_document_type | Format-Table -AutoSize
