# Paper Reading

This is a public-by-default Obsidian system for tracking paper reading during PhD research.

The system is designed for three goals:

- remember papers clearly after weeks or months;
- turn reading into research taste, connections, and ideas;
- track reading discipline without making metadata maintenance expensive.

## Core Workflow

1. Add a paper to Zotero and save the PDF there or under `_attachments/PDFs/`.
2. Create one Markdown note for the paper using a template from `_templates/`.
3. Put the note in the most useful topic folder.
4. Fill the frontmatter fields needed for dashboards and MOCs.
5. Write the note at the right depth: `skim`, `standard`, `deep`, or `paper-with-code`.
6. Let MOCs and dashboards collect the notes automatically through Dataview queries.

## Depth Levels

- `skim`: less than one hour, often AI-assisted. Capture problem, core idea, evidence, conclusions, and why it matters.
- `standard`: enough detail to cite or compare. Add method structure, assumptions, evaluation design, limitations, and related work.
- `deep`: foundational or field-shaping papers. Reconstruct the method, evidence, influence, limitations, and reusable research patterns.
- `paper-with-code`: a deep note plus implementation, reproduction, code map, commands, and experimental observations.

## Status Values

- `inbox`: captured but not triaged.
- `queued`: selected for reading.
- `reading`: actively being read.
- `done`: note is good enough for its intended depth.
- `archived`: kept for context but not active.

## Public Policy

This repository is public by default. Keep private material in `_private/` or mark a note with `publish: false`.

PDFs should not be committed. Use Zotero or `_attachments/PDFs/` for local copies.

## Main Files

- `_catalog/CATALOG.md`: folder taxonomy and placement rules.
- `_catalog/METADATA.md`: required frontmatter conventions.
- `_catalog/ZOTERO_AND_PUBLISHING.md`: how Zotero, BibTeX, PDFs, and GitHub fit together.
- `_templates/`: note templates for skim, deep, and paper-with-code reading.
- `_dashboards/`: Dataview dashboards for active reading and review.
