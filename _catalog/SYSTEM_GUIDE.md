# Paper Reading System Operating Manual

This repository is a public-by-default Obsidian paper reading system for PhD research. It is designed to make paper reading cumulative: each paper should become easier to remember, compare, cite, and connect to future research ideas.

## Core Principles

1. Zotero owns bibliographic identity.
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
| Dashboards | operational views for reading queue and review | generated from frontmatter |
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
status: inbox
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

Do not let metadata maintenance become the work. It is acceptable for old notes to have sparse metadata until they become relevant.

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

A paper enters the system when you decide it is worth at least a skim.

Minimum intake:

1. Add the paper to Zotero.
2. Put it in the Zotero `Paper Reading` collection.
3. Let Better BibTeX update `_private/zotero/paper-reading.bib`.
4. Create or update one Obsidian note.
5. Run Zotero sync.

```powershell
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib -Apply
```

The first command is a dry run. The second applies safe bibliographic updates.

### 3. Triage

Set:

```yaml
status: queued
depth: skim|standard|deep|paper-with-code
importance: 1-5
```

Do not overuse `deep`. Most papers should be skimmed. Deep reading is for foundational, thesis-central, or unusually clarifying papers.

### 4. Reading

Use the note template matching the reading depth. During AI-assisted reading, the agent should help you answer:

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

Use:

- `_dashboards/Reading Inbox.md` for untriaged notes;
- `_dashboards/Reading Now.md` for active notes;
- `_dashboards/Recently Read.md` for memory refresh;
- `_dashboards/Important Papers.md` for high-importance review;
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

1. Add the metadata item to Zotero from arXiv/DOI when possible.
2. Attach or link the downloaded PDF to that Zotero item.
3. Put the PDF under `_attachments/PDFs/...` only after deciding the Obsidian category.
4. Sync metadata into the Obsidian note.

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
2. If worth reading, save to Zotero from the abstract page using the browser connector.
3. Put it in `Paper Reading`.
4. Check metadata quickly: title, authors, year, venue, DOI/arXiv, citation key.
5. Decide Obsidian location.
6. If a local PDF is desired, move/copy it to `_attachments/PDFs/<note path>.pdf`.
7. Create the note scaffold.
8. Run Zotero sync.
9. Start an AI-assisted reading session.
10. After reading, update `status`, `depth`, `importance`, `date_read`, and `has_ideas`.

## Existing PDF Workflow

Use this when the PDF is already under `_attachments/PDFs/...` but not in Zotero.

1. Open the PDF or note.
2. Identify DOI or arXiv ID if available.
3. Add the paper to Zotero by identifier, or drag/link the PDF into Zotero and retrieve metadata.
4. Put the item in `Paper Reading`.
5. Fix metadata only if the paper is important or actively being read.
6. Run Zotero sync.
7. Read with Codex.

## Starting A Codex Reading Session

Start Codex from this repository root. Give it the note path, PDF path or Zotero item, desired depth, and research context.

Minimal prompt:

```text
I want to read <paper title>. The note is <note path>. The PDF is <pdf path or Zotero item>. Read it with me at <skim|standard|deep|paper-with-code> depth. Focus on problem, method, evidence, limitations, related work, and ideas relevant to my research. Ask me questions when needed. Do not overwrite existing human notes. Update the note when we have enough understanding.
```

Use `_catalog/AI_AGENT_PROMPTS.md` for full prompt templates.

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

- Review `Reading Inbox` and `Reading Now`.
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

Stop adding papers for a week. Triage first. Most should become `archived` or remain Zotero-only.

### Zotero Metadata Is Wrong

Fix Zotero for important papers only. Then rerun sync. Do not waste time perfecting metadata for papers you may never read.

### A Paper Fits Multiple Topics

Place the note where you would look for it first. Use `topics` and `tags` for cross-listing.

### MOCs Become Too Long

Split synthesis into sections, not necessarily folders. Create a new MOC only when it supports repeated revisiting.

### AI Summary Feels Generic

Force the agent to answer concrete questions: what problem, what method, what evidence, what limitation, what changes for your research.