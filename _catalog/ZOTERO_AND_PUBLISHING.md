# Zotero And Publishing

## Decision

Zotero owns bibliographic identity. Obsidian owns understanding.

- Zotero: bibliographic metadata, citation keys, item keys, DOI/arXiv links, canonical PDFs, and bibliography exports.
- Obsidian: paper memory, problem/method/experiment notes, synthesis, reading status, importance, topics, MOCs, and ideas.
- Better BibTeX: stable `citation_key` values and an automatically updated BibTeX or BibLaTeX export.
- GitHub: public Markdown notes, templates, MOCs, dashboards, and scripts.

Do not commit PDFs, Zotero databases, private annotations, private review notes, or unpublished research ideas.

## First-Time Zotero Setup

1. Install Zotero desktop and the Zotero browser connector.
2. Install Better BibTeX for Zotero.
3. In Zotero, create one main collection named `Paper Reading`.
4. Optional: create only coarse subcollections such as `SciML`, `LLMs`, `Mathematics`, `AI for Science`, and `Computer Vision`.
5. Let Obsidian handle fine-grained topic structure. Do not mirror the full Obsidian folder tree in Zotero.
6. In Better BibTeX preferences, keep citation keys stable after creation.
7. Create an automatic export of the `Paper Reading` collection to a private path such as:

```powershell
_private\zotero\paper-reading.bib
```

Use Better BibTeX or Better BibLaTeX. The sync script supports common fields from both.

## PDF Policy

PDFs are ignored by git. There are two acceptable local modes:

- Linked-file mode: Zotero items point to PDFs under `_attachments/PDFs/...`.
- Stored-file mode: Zotero stores PDFs in its own storage directory, while Obsidian notes keep `pdf:` paths only when a local copy exists.

For this vault, linked-file mode is the lowest-friction choice because Obsidian links already point into `_attachments/PDFs/...`. Zotero still owns metadata and citation keys.

## Daily Reading Workflow

### New Paper From The Web

1. Open the paper abstract page, not just the raw PDF, when possible.
2. Click the Zotero browser connector.
3. Check title, authors, year, venue, DOI, and arXiv ID once.
4. Put the item in the `Paper Reading` collection.
5. Let Better BibTeX update `_private/zotero/paper-reading.bib`.
6. Create or sync the Obsidian note.
7. Read and write the actual understanding in Obsidian.

### Existing Imported PDFs

1. Add the local PDF to Zotero as a linked file.
2. Use Zotero metadata retrieval or add by DOI/arXiv when available.
3. Put the item in `Paper Reading`.
4. Run the sync script from this repo.

```powershell
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib -Apply
```

The first command is a dry run. The second writes only safe bibliographic fields.

## Sync Rules

The sync script matches notes to Zotero export entries in this order:

1. DOI
2. arXiv ID, ignoring version suffixes like `v2`
3. normalized title

By default it fills blank bibliographic fields only:

- `authors`
- `year`
- `venue`
- `citation_key`
- `zotero_key`
- `zotero_uri`
- `zotero_pdf_uri`
- `url`
- `doi`
- `arxiv`

It does not modify:

- `status`
- `depth`
- `importance`
- `topics`
- `tags`
- any reading-note body sections

Use `-OverwriteBibliographicFields` only when Zotero is known to be cleaner than the current note metadata.

## Frictionless Defaults

The boring path should be one command:

```powershell
.\scripts\sync-zotero-metadata.ps1 -BibFile _private\zotero\paper-reading.bib -Apply
```

Recommended habits:

- Add papers through the Zotero connector whenever possible.
- Keep one stable citation key per paper.
- Let the sync script fill metadata.
- Let MOCs and dashboards read Obsidian frontmatter.
- Spend manual attention only on paper understanding, topic placement, importance, and ideas.

## What To Keep Private

Use `_private/` or `publish: false` for:

- advisor or collaborator comments;
- unpublished project connections;
- private experiment results;
- detailed annotations that quote too much from copyrighted PDFs;
- full BibTeX exports if you do not want your full library public.

## Useful Links

- Zotero adding items: https://www.zotero.org/support/adding_items_to_zotero
- Zotero PDF metadata retrieval: https://www.zotero.org/support/retrieve_pdf_metadata
- Zotero file attachments: https://www.zotero.org/support/attaching_files
- Better BibTeX: https://retorque.re/zotero-better-bibtex/
- Better BibTeX automatic export: https://retorque.re/zotero-better-bibtex/exporting/auto/