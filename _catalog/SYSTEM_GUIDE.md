# Paper Reading System Operating Manual

This repository is a public-by-default Obsidian paper reading system for PhD research. It is designed to make paper reading cumulative: each paper should become easier to remember, compare, cite, and connect to future research ideas.

## Core Principles

1. Zotero owns bibliographic identity once a paper is active or citation-relevant.
2. Obsidian owns understanding.
3. The filesystem helps retrieval, but metadata drives dashboards and MOCs.
4. AI agents automate intake, scaffolding, metadata cleanup, and first-pass explanation.
5. Human attention is reserved for judgment: why the paper matters, what it actually proves, how it relates to your research, and what ideas it triggers.

## System Components

| Component | Role | Source of Truth |
| --- | --- | --- |
| Zotero | bibliographic metadata, citation keys, item identity, canonical paper record | yes for metadata |
| Better BibTeX | stable citation keys and auto-exported `.bib` file | yes for `citation_key` |
| Obsidian notes | memory, understanding, synthesis, status, reading depth, ideas | yes for knowledge |
| `_attachments/PDFs/` | optional local PDF mirror for Obsidian convenience | no, ignored by git |
| MOCs | synthesis pages and navigational maps | yes for field understanding |
| Dashboards | one hand-maintained weekly queue plus one generated library review page | mixed: `This Week` is manual, `Library Views` is generated |
| GitHub | public versioned notes, docs, templates, MOCs, scripts | public layer only |

## Zotero Is Not A Folder Mirror

The Zotero collection does not need to match the Obsidian folder tree. This is intentional.

Use Zotero for identity:

- Is this the exact paper?
- What is its citation key?
- What are the authors, year, DOI, arXiv ID, and venue?
- Is there already a duplicate item?

Use Obsidian for meaning:

- Where would I look for this paper later?
- Which MOCs should it appear in?
- Is it important to SciML, Neural Operators, LLMs, AI for Science, or another research thread?
- What did I learn from it?

A paper can live in one Zotero collection but appear in many Obsidian topics through `topics` and `tags`.

## Standard Frontmatter Contract

Every paper note should follow `_catalog/METADATA.md`. The fields with the highest operational value are:

```yaml
note_type: paper
title:
authors: []
year:
venue:
status: library
depth: skim
importance: 3
topics: []
tags: []
citation_key:
zotero_key:
zotero_uri:
url:
doi:
arxiv:
pdf:
date_added:
date_read:
has_ideas: false
publish: true
```

Do not let metadata maintenance become the work. It is acceptable for old notes to have sparse metadata until they become relevant. Use `status: library` for passive collected placeholders, and reserve `inbox`, `queued`, and `reading` for papers that need near-term attention.

## Paper Lifecycle

### 1. Candidate

A candidate paper is something you might read. It does not need an Obsidian note yet.

Typical sources:

- advisor or collaborator recommendation;
- citation from a paper you just read;
- survey or tutorial reading list;
- arXiv, conference, or Semantic Scholar search;
- papers that repeatedly appear in related work;
- papers needed to understand a method, benchmark, theorem, or claim.

### 2. Intake

A paper enters the active reading workflow when you decide it is worth at least a skim. A bulk-imported or newly collected PDF can stay as `status: library` until it becomes relevant.

Minimum intake before reading:

1. Create or update one Obsidian note.
2. Fill the best available `url`, `doi`, `arxiv`, and `pdf` fields.
3. Set `status`, `depth`, `importance`, `topics`, and `tags` deliberately.
4. Add the note to `_dashboards/This Week.md` only if it needs near-term attention.

Zotero intake, when the paper becomes active or citation-relevant:

1. Add the paper to Zotero.
2. Put it in the Zotero `Paper Reading` collection.
3. Let Better BibTeX update `_private/zotero/paper-reading.bib`.
4. Run Zotero sync.

```powershell
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib -Apply
```

The first command is a dry run. The second applies safe bibliographic updates after Zotero and Better BibTeX are set up. Reading can start before this sync if the note has a PDF or source identifier.

### 3. Triage

Set:

```yaml
status: queued
depth: skim|standard|deep|paper-with-code
importance: 1-5
```

Do not overuse `deep`. Most papers should be skimmed. Deep reading is for foundational, thesis-central, or unusually clarifying papers.

### 4. Reading

Use the note template and prompt template matching the reading depth: skim, standard, deep, or paper-with-code. During AI-assisted reading, the agent should help you answer:

- What problem is the paper solving?
- Why was the problem important at the time?
- What is the core idea?
- What is the actual method?
- What evidence supports the claims?
- What are the limitations?
- What prior and follow-up work define the paper's position?
- What reusable research pattern or idea should be remembered?

### 5. Completion

A paper is `done` when the note is good enough for its intended depth, not when every detail is understood.

Set:

```yaml
status: done
date_read: YYYY-MM-DD
has_ideas: true|false
```

If the note produced private research ideas, either place them under `_private/` or mark the note `publish: false` before committing.

### 6. Review

Review should happen through dashboards and MOCs, not by browsing folders randomly.

Use `_dashboards/This Week.md` as the only operational reading queue. Use `_dashboards/Library Views.md` only as a generated reference page for inbox, active notes, recent completions, important papers, ideas, and deep-reading views.

Use:

- `_dashboards/This Week.md` for near-term reading order;
- `_dashboards/Library Views.md` for generated review views;
- topic MOCs for synthesis.

## PDF Policy

PDFs are local working files, not public knowledge artifacts. They are ignored by git.

### New Paper PDFs

Preferred workflow:

1. Save the paper to Zotero from the arXiv, DOI, or publisher page using the browser connector.
2. If you want an Obsidian-local PDF copy, place it under:

```text
_attachments/PDFs/<same folder path as note>/<paper title>.pdf
```

Example:

```text
LLMs/Pretraining/Architectures/Attention is All You Need.md
_attachments/PDFs/LLMs/Pretraining/Architectures/Attention is All You Need.pdf
```

Use the Obsidian-local copy for fast local linking. Use Zotero for metadata identity.

### Downloaded PDF Before Zotero

If you already downloaded the PDF manually:

1. Put the PDF under `_attachments/PDFs/...` only after deciding the Obsidian category.
2. Create or update the matching Obsidian note.
3. Fill DOI/arXiv/URL from the PDF or source page when available.
4. Add the paper to Zotero later if it becomes active, important, or citation-relevant.

### Legacy 800+ PDFs

Do not import all 800 PDFs blindly into Zotero unless you are prepared for metadata cleanup. Use a staged migration.

Recommended approach:

1. Keep the existing Obsidian PDF mirror as-is.
2. Add papers to Zotero when they become active reading targets.
3. For important folders, batch-import 25-50 PDFs at a time into a temporary Zotero collection named `Legacy Import Review`.
4. Use Zotero PDF metadata retrieval or DOI/arXiv lookup.
5. Correct title, date, venue, and citation key for important papers.
6. Move clean Zotero items into `Paper Reading`.
7. Leave unresolved or low-value PDFs outside Zotero until they matter.

This keeps Zotero curated instead of turning it into another untrusted pile.

## New Paper Workflow

Use this when you encounter a new paper online.

1. Ask: is this worth reading now, later, or never?
2. Decide Obsidian location.
3. Create the note scaffold or update the existing note.
4. Fill `url`, `doi`, `arxiv`, and `pdf` from the source page or local PDF when available.
5. If a local PDF is desired, move/copy it to `_attachments/PDFs/<note path>.pdf`.
6. If reading this week, add the note to `_dashboards/This Week.md` and set `status: queued`.
7. Start an AI-assisted reading session; set `status: reading` when the session begins.
8. After reading, update `status`, `depth`, `importance`, `date_read`, and `has_ideas`.
9. Add the paper to Zotero and run sync when it becomes active, important, or citation-relevant.

## Existing PDF Workflow

Use this when the PDF is already under `_attachments/PDFs/...` but not in Zotero.

1. Open the PDF or note.
2. Identify DOI or arXiv ID if available.
3. Make sure the note has a correct `pdf` path and source identifier if possible.
4. If reading this week, add the note to `_dashboards/This Week.md` and set `status: queued`.
5. Read with Codex; set `status: reading` when the session begins.
6. Add the paper to Zotero and run sync when it becomes active, important, or citation-relevant.

## Starting A Codex Reading Session

Start Codex from this repository root. Use the matching prompt template under `_templates/Prompt - *.md`, then fill in the note path, PDF path or Zotero item, desired depth, and research context.

Minimal prompt:

```text
I want to read <paper title>. The note is <note path>. The PDF is <pdf path or Zotero item>. Read it with me at <skim|standard|deep|paper-with-code> depth. Focus on problem, method, evidence, limitations, related work, and ideas relevant to my research. Ask me questions when needed. Do not overwrite existing human notes. Update the note when we have enough understanding.
```

Use `_templates/Prompt - Skim Reading.md`, `_templates/Prompt - Standard Reading.md`, `_templates/Prompt - Deep Reading.md`, or `_templates/Prompt - Paper With Code.md` for depth-specific session starts. `_catalog/AI_AGENT_PROMPTS.md` remains the reference copy.

## How AI Agents Should Update Notes

Agents may:

- fill missing bibliographic metadata from Zotero/BibTeX;
- create a scaffold from a template;
- summarize the paper at the requested depth;
- explain equations and methods;
- update note sections;
- suggest topic/tag corrections;
- suggest MOC synthesis updates.

Agents must not:

- overwrite human-written interpretation without confirmation;
- mark a paper `done` unless the note is good enough for the requested depth;
- commit PDFs or private notes;
- add speculative private research ideas to public notes;
- create low-value MOCs for tiny leaf folders.

## MOC Maintenance

MOCs should live at high-level or synthesis-level folders. Folders can be fine-grained; MOCs should not be.

A MOC should combine:

- an auto-generated Dataview table;
- a human or AI-assisted synthesis of the topic;
- foundational papers;
- method families;
- open problems;
- active reading queue;
- links to adjacent topics.

The table is automatic. The synthesis is maintained manually or with AI help.

Create or refresh a MOC when:

- the topic has around 10 papers;
- you are preparing a survey, proposal, or related-work section;
- you keep revisiting the topic;
- the field structure is changing in your mind.

## Maintenance Cadence

### Per Paper

- Add to Zotero.
- Check metadata once.
- Create/sync note.
- Read at chosen depth.
- Mark status and date.

### Weekly

- Review `_dashboards/This Week.md`; open `_dashboards/Library Views.md` only when you intentionally want generated review views.
- Promote or archive queued papers.
- Fix obvious category mistakes.
- Refresh one central MOC if needed.

### Monthly

- Review important papers.
- Consolidate duplicated ideas.
- Move private ideas to `_private/` or separate project notes.
- Check whether any folder needs a new MOC.

## Failure Modes

### Too Many Papers In Inbox

Do not use `inbox` for bulk collection. Keep passive placeholders as `status: library`; only add near-term papers to `_dashboards/This Week.md`.

### Zotero Metadata Is Wrong

Fix Zotero for important papers only. Then rerun sync. Do not waste time perfecting metadata for papers you may never read.

### A Paper Fits Multiple Topics

Place the note where you would look for it first. Use `topics` and `tags` for cross-listing.

### MOCs Become Too Long

Split synthesis into sections, not necessarily folders. Create a new MOC only when it supports repeated revisiting.

### AI Summary Feels Generic

Force the agent to answer concrete questions: what problem, what method, what evidence, what limitation, what changes for your research.
