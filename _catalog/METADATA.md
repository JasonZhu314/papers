# Metadata

Use this frontmatter shape for paper notes. AI agents can fill most bibliographic fields, but the subjective fields should remain intentional.

```yaml
---
note_type: paper
title:
aliases: []
authors: []
year:
venue:
paper_type: research
status: inbox
depth: skim
importance: 3
topics: []
tags: []
citation_key:
zotero_key:
url:
doi:
arxiv:
pdf:
date_added:
date_read:
has_ideas: false
publish: true
---
```

## Required Fields

- `title`: full paper title.
- `note_type`: use `paper` for paper notes. MOCs and dashboards use other values so they are excluded from paper queries.
- `authors`: author list or shortened author string.
- `year`: publication or preprint year.
- `venue`: venue, arXiv, workshop, journal, or unknown.
- `status`: `inbox`, `queued`, `reading`, `done`, or `archived`.
- `depth`: `skim`, `standard`, `deep`, or `paper-with-code`.
- `importance`: 1 to 5, where 5 means foundational or directly central.
- `topics`: MOC-facing topic names, such as `SciML`, `Operator Learning`, or `LLMs`.
- `tags`: fine-grained cross-cutting labels.
- `publish`: `true` unless the note contains private material.

## Optional But Useful Fields

- `citation_key`: stable key for citations and MOCs.
- `zotero_key`: Zotero item key if available.
- `url`, `doi`, `arxiv`: source identifiers.
- `pdf`: local path or Zotero pointer. Do not commit PDFs.
- `date_added`: when the paper entered the system.
- `date_read`: when the note became good enough for its intended depth.
- `has_ideas`: set to `true` when the paper produced concrete research ideas.

## Topic Versus Tag

Use `topics` for MOC membership. Use `tags` for details.

Example:

```yaml
topics:
  - SciML
  - Operator Learning
tags:
  - neural-operator
  - fno
  - pde-surrogate
  - fourier-method
```
