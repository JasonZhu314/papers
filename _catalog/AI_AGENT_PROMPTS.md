# AI Agent Prompts

These prompts are designed for Codex or another AI agent running from the repository root. Replace placeholders before use.

## Reading Workflow Contract

Paper reading is interactive by default. A durable Obsidian note is generated only after the reading conversation is complete.

Each depth-specific prompt has three phases:

1. Starter prompt: begin a Codex reading session with the right context and rules.
2. Interactive prompts: ask for clarification, section guidance, critique, checkpoints, and idea generation while reading.
3. Final note prompt: generate or update the Obsidian note after the user understands the paper.

During starter and interactive phases, the agent should not fill the final note body. It may make only minimal lifecycle edits, such as setting `status: reading`, when the user explicitly asks.

## General Agent Rules

Use this block at the top of any serious reading or maintenance session.

```text
You are helping maintain my Obsidian paper reading system. Work from this repository root.

Rules:
- Use the existing note if it exists; do not create duplicates.
- Do not overwrite human-written interpretation without asking.
- Preserve frontmatter fields unrelated to the task.
- Do not commit PDFs, BibTeX exports, Zotero databases, or private notes.
- Keep private research ideas out of public notes unless I explicitly approve.
- Prefer Zotero/Better BibTeX metadata for authors, year, DOI, arXiv, and citation key when available.
- Use the note's requested depth: skim, standard, deep, or paper-with-code.
- In reading sessions, help me understand interactively before generating notes.
- Generate or update the durable note only when I use the final note prompt or explicitly ask for finalization.
- Focus on understanding and research judgment, not generic summary.
```

## Depth Template Matrix

| Depth | Note template | Agent prompt template |
| --- | --- | --- |
| skim | `_templates/Paper - Skim.md` | `_templates/Prompt - Skim Reading.md` |
| standard | `_templates/Paper - Standard.md` | `_templates/Prompt - Standard Reading.md` |
| deep | `_templates/Paper - Deep Reading.md` | `_templates/Prompt - Deep Reading.md` |
| paper-with-code | `_templates/Paper - Paper With Code.md` | `_templates/Prompt - Paper With Code.md` |

Use `_dashboards/This Week.md` as the only active queue. Use `_dashboards/Library Views.md` for generated review views. Do not maintain separate queue tags or static queue tables unless the user explicitly asks.

## Intake A New Paper

```text
I want to add a new paper to my reading system.

Paper:
- title: <title>
- URL/arXiv/DOI: <identifier>
- local PDF, if any: <path or none>
- expected topic: <topic guess>
- intended depth: <skim|standard|deep|paper-with-code>
- why I care: <reason>

Please:
1. Check whether a note already exists.
2. Suggest the correct Obsidian folder and topics.
3. Create or update the note scaffold using the repository metadata conventions.
4. Keep the PDF path consistent with `_attachments/PDFs/<note path>.pdf` if there is a local PDF.
5. Run Zotero metadata sync if `_private/zotero/paper-reading.bib` is available.
6. Do not generate reading notes or summaries during intake.
7. Report any metadata ambiguities rather than guessing.
```

## Reading Sessions

Use the depth-specific prompt templates listed above. They are the source of truth for reading-session starts, in-session help, and final note generation.

Do not paste the final note prompt at the start of a reading session. Use it only after the paper has been discussed and the user can state their final takeaways.

## Zotero Metadata Sync

```text
Please sync Zotero metadata into my paper notes.

Use `_private/zotero/paper-reading.bib`.

Steps:
1. Run a dry sync.
2. Inspect ambiguous and would-update rows.
3. Apply only if changes are safe.
4. Do not overwrite reading status, depth, importance, topics, tags, or note body.
5. Do not commit private Zotero exports or PDFs.
6. Report matched, updated, ambiguous, and unmatched counts.
```

## Category Correction Pass

```text
Please audit paper categorization.

Scope: <folder or whole repo>

Rules:
- Decide from title/frontmatter first; inspect PDF only when needed.
- Move the note and matching ignored PDF together if the category is clearly wrong.
- Update `topics` and `pdf` frontmatter to match the new path.
- Do not create a new MOC for small leaf folders.
- Produce a private audit report for ambiguous cases.
- Commit only public Markdown/path changes, not PDFs or private reports.
```

## MOC Refresh

```text
Please refresh the MOC for <topic>.

MOC path: <path>
Scope folders/topics: <scope>

Please:
1. Keep the Dataview table working.
2. Update synthesis sections: field map, foundational papers, method families, open problems, reading queue.
3. Do not manually list every paper if Dataview already covers it.
4. Highlight papers that deserve deeper reading.
5. Keep speculative unpublished ideas private or mark the MOC `publish: false` if needed.
```

## Weekly Maintenance

```text
Please run weekly maintenance for my paper reading system.

Goals:
1. Review `_dashboards/This Week.md` as the active queue.
2. Identify papers that should stay this week, move out of the week, or be promoted to deep reading.
3. Use `_dashboards/Library Views.md` for generated checks of inbox, active notes, important papers, ideas, and deep-reading papers.
4. Check for obvious metadata, Zotero, or category problems.
5. Suggest one MOC that should be refreshed.
6. Do not make broad changes without showing the proposed actions first.
```

## Note Finalization

```text
Please finalize this paper note from our completed reading session.

Note: <note path>
Intended depth: <skim|standard|deep|paper-with-code>
Today's date: <YYYY-MM-DD>
My final takeaways: <takeaways>
Unresolved questions: <questions>
Private ideas to avoid publishing: <private ideas or none>

Check whether the note is complete for that depth:
- problem and motivation;
- core idea;
- method;
- experiments/evaluation;
- theory if relevant;
- related work;
- limitations;
- connections and ideas.

Then update frontmatter:
- `status: done` only if complete enough;
- `date_read: <today>`;
- `has_ideas: true|false`;
- `importance: <1-5>` if clear.

Preserve human-written content, mark uncertainty, and report remaining gaps.
```