# Paper Reading System Operating Manual

This repository is a public-by-default Obsidian paper reading system for PhD research. It is designed to make paper reading cumulative: each paper should become easier to remember, compare, cite, and connect to future research ideas.

## Core Principles

1. Zotero owns bibliographic identity once a paper is active or citation-relevant.
2. Obsidian owns understanding.
3. The filesystem helps retrieval, but metadata drives dashboards and MOCs.
4. AI agents support intake, scaffolding, metadata cleanup, interactive explanation, and final note generation after reading.
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

### 4. Interactive Reading

Use the prompt template matching the reading depth: skim, standard, deep, or paper-with-code.

A reading session has three phases:

1. Starter prompt: give the agent the note path, PDF or Zotero item, research context, and depth-specific instructions.
2. Interactive reading: ask for section guidance, clarification, equation explanations, checkpoints, critique, and idea generation while you read.
3. Final note prompt: generate the durable Obsidian note after the paper is understood.

During starter and interactive phases, the agent should keep work in the conversation. It should not fill the final note body, summarize the whole paper into the note, or mark the paper `done`. If you explicitly ask, it may make minimal lifecycle edits such as setting `status: reading`, but the actual note should be produced only at the end.

The agent should help you answer:

- What problem is the paper solving?
- Why was the problem important at the time?
- What is the core idea?
- What is the actual method?
- What evidence supports the claims?
- What are the limitations?
- What prior and follow-up work define the paper's position?
- What reusable research pattern or idea should be remembered?

### 5. Completion

A paper is `done` when the final note is good enough for its intended depth, not when every detail is understood.

After the interactive reading conversation is complete, use the final note prompt from the matching `_templates/Prompt - *.md` file. The final prompt should tell the agent your takeaways, unresolved questions, and any private ideas that must not be published.

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
7. Start an AI-assisted reading session with the depth-specific starter prompt.
8. Read interactively. Use the agent for clarification, section guidance, critical checks, and idea prompts.
9. After reading, use the final note prompt to generate the note and update `status`, `depth`, `importance`, `date_read`, and `has_ideas`.
10. Add the paper to Zotero and run sync when it becomes active, important, or citation-relevant.

## Existing PDF Workflow

Use this when the PDF is already under `_attachments/PDFs/...` but not in Zotero.

1. Open the PDF or note.
2. Identify DOI or arXiv ID if available.
3. Make sure the note has a correct `pdf` path and source identifier if possible.
4. If reading this week, add the note to `_dashboards/This Week.md` and set `status: queued`.
5. Start Codex with the matching depth-specific starter prompt.
6. Read interactively; do not generate the final note until the paper is understood.
7. Add the paper to Zotero and run sync when it becomes active, important, or citation-relevant.

## Starting A Codex Reading Session

Start Codex from this repository root. Open the matching prompt template under `_templates/Prompt - *.md` and paste the Starter Prompt, filling in the note path, PDF path or Zotero item, desired depth, research context, and questions.

Minimal starter prompt:

```text
I want to read <paper title> interactively at <skim|standard|deep|paper-with-code> depth.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
My research context: <context>
Specific questions I care about: <questions>

Do not generate or fill the final Obsidian note yet. Guide my reading, answer questions, explain sections, critique evidence, and prompt me to think. We will generate the note only after I say the reading is complete.
```

During the session, use the Interactive Reading Prompts from the same template file whenever you want clarification, a checkpoint, a critique, or idea generation.

When the reading is complete, paste the Final Note Prompt from the same template file. That is the point where the agent should generate or update the durable note.

Do not use the final note prompt at the beginning of a reading session.

## How AI Agents Should Update Notes

During starter and interactive reading phases, agents should not fill the final note body. They may:

- inspect the PDF or source material;
- answer questions and explain sections;
- suggest what to read next;
- test the user's understanding;
- critique evidence and limitations;
- suggest possible ideas in the conversation;
- make minimal lifecycle edits, such as setting `status: reading`, only when explicitly asked.

During finalization, agents may:

- fill missing bibliographic metadata from Zotero/BibTeX or the paper;
- create or update a note from the appropriate template;
- synthesize the completed reading conversation into a durable note;
- update `status`, `date_read`, `has_ideas`, `importance`, and depth-specific fields;
- suggest topic/tag corrections;
- suggest MOC synthesis updates.

Agents must not:

- generate a completed paper note before the reading conversation is done;
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

### Reading Session Feels Generic

Use the interactive prompts to force concrete work: section guidance, explain-back checkpoints, evidence critique, limitations, and what changes for your research. Do not ask for a final note until you can state your own takeaways.
