# Zotero And Publishing

## Division Of Responsibility

- Zotero: bibliographic metadata, PDFs, DOI/arXiv links, collections, and citation keys.
- Obsidian: understanding, synthesis, research ideas, MOCs, and dashboards.
- BibTeX: export layer for writing papers.
- GitHub: public notes, templates, MOCs, and reading progress.

## Recommended Zotero Setup

Use Zotero as the source of truth for PDFs and citation metadata. Keep a stable citation key for each paper so paper notes can reference it with `citation_key`.

Useful Zotero conventions:

- one collection for broad reading areas, such as `SciML`, `LLMs`, and `Computer Vision`;
- saved PDFs attached to Zotero items;
- exported BibTeX/BibLaTeX only when needed for paper writing;
- Obsidian notes linked back to Zotero through `zotero_key` or `citation_key`.

## PDFs

PDFs are intentionally ignored by Git.

Good options:

- store PDFs in Zotero only;
- store local copies under `_attachments/PDFs/`;
- include official links, arXiv links, DOI, or Zotero keys in paper notes.

Do not commit copyrighted PDFs to the public repository.

## Public Notes

The default is `publish: true`. Use `publish: false` for notes containing:

- private project connections;
- advisor or collaborator comments;
- unpublished research ideas;
- private experiment results;
- anything that should not be in a public GitHub repository.
