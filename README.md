# Paper Reading

This is a public-by-default Obsidian system for tracking paper reading during PhD research.

The system is designed for three goals:

- remember papers clearly after weeks or months;
- turn reading into research taste, connections, and ideas;
- track reading discipline without making metadata maintenance expensive.

## Start Here

Read these docs in order:

1. `_catalog/SYSTEM_GUIDE.md`: operating manual for the full paper reading system.
2. `_catalog/READING_METHODOLOGY.md`: how to select papers, choose reading depth, and read for research.
3. `_catalog/AI_AGENT_PROMPTS.md`: reusable prompts for Codex and other AI agents.
4. `_catalog/ZOTERO_AND_PUBLISHING.md`: Zotero, Better BibTeX, PDFs, and public/private boundaries.
5. `_catalog/CATALOG.md`: folder taxonomy and placement rules.
6. `_catalog/METADATA.md`: frontmatter schema.

## Core Workflow

1. Select a paper worth at least skimming.
2. Create or update one Markdown note in the correct Obsidian topic folder.
3. Fill the best available identifiers: `url`, `doi`, `arxiv`, and `pdf`.
4. If a local PDF copy is useful, keep it under `_attachments/PDFs/<same path as note>.pdf`.
5. Put near-term papers in `_dashboards/This Week.md`; keep passive placeholders as `status: library`.
6. Read with the right depth: `skim`, `standard`, `deep`, or `paper-with-code`.
7. When the paper becomes active or citation-relevant, add it to Zotero collection `Paper Reading` and sync metadata.

```powershell
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib -Apply
```

The first command is a dry run. The second fills safe bibliographic metadata after Zotero and Better BibTeX are set up. Zotero is useful, but it is not required before the first reading session.

## Depth Levels

- `skim`: less than one hour, often AI-assisted. Capture problem, core idea, evidence, conclusions, and why it matters.
- `standard`: enough detail to cite or compare. Add method structure, assumptions, evaluation design, limitations, and related work.
- `deep`: foundational or field-shaping papers. Reconstruct the method, evidence, influence, limitations, and reusable research patterns.
- `paper-with-code`: a deep note plus implementation, reproduction, code map, commands, and experimental observations.

## Status Values

- `library`: collected placeholder, not part of the active reading workflow.
- `inbox`: captured for near-term triage.
- `queued`: selected for reading.
- `reading`: actively being read.
- `done`: note is good enough for its intended depth.
- `archived`: kept for context but not active.

## Downloaded PDF Quick Path

If you downloaded a new paper PDF:

1. Decide whether it is for this week or just collection.
2. Put the PDF under `_attachments/PDFs/<topic path>/<paper title>.pdf`.
3. Create or update one note in the matching topic folder.
4. If reading this week, add the note to `_dashboards/This Week.md` and use the matching prompt from `_templates/Prompt - *.md`.
5. If just collecting, leave it as `status: library` and do not add it to the weekly queue.

## Public Policy

This repository is public by default. Keep private material in `_private/` or mark a note with `publish: false`.

Do not commit:

- PDFs;
- Zotero databases;
- BibTeX exports from the private library;
- private advisor/collaborator comments;
- unpublished project ideas;
- private experiment results.

## Main Files

- `_catalog/SYSTEM_GUIDE.md`: full operating manual.
- `_catalog/READING_METHODOLOGY.md`: paper selection and reading methodology.
- `_catalog/AI_AGENT_PROMPTS.md`: prompt templates for AI-assisted intake, reading, sync, and MOC refresh.
- `_catalog/CATALOG.md`: folder taxonomy and placement rules.
- `_catalog/METADATA.md`: required frontmatter conventions.
- `_catalog/ZOTERO_AND_PUBLISHING.md`: how Zotero, BibTeX, PDFs, and GitHub fit together.
- `_templates/`: note templates and prompt templates for skim, standard, deep, and paper-with-code reading.
- `_dashboards/This Week.md`: the only hand-maintained reading queue.
- `_dashboards/Library Views.md`: generated Dataview review sections; do not maintain reading order there.
