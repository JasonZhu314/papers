# Repository Instructions

This repository is a public-by-default Obsidian paper reading system.

## Public And Private Material

- Paper notes are public unless they are placed under `_private/` or explicitly marked `publish: false`.
- Do not commit PDFs, copyrighted paper copies, private advisor comments, unpublished project ideas, credentials, or private experiment results.
- Keep PDFs in Zotero or `_attachments/PDFs/`; that directory is ignored except for `.gitkeep` placeholders.

## Paper Notes

- Use one Markdown note per paper.
- Use human-readable filenames.
- Keep citation keys in frontmatter and MOCs, not as the main filename requirement.
- Every paper note should have frontmatter compatible with `_catalog/METADATA.md`.
- Choose `depth` deliberately: `skim`, `standard`, `deep`, or `paper-with-code`.

## Organization

- Folders can be fine-grained for placement.
- MOCs should live at high-level or synthesis-level folders only.
- Create a new MOC only when it will support synthesis or repeated revisiting, usually after a topic has around 10 papers.
- Prefer metadata and tags for small distinctions such as `fno`, `rlhf`, `vit`, or `denoising`.
