# AI Agent Prompts

These prompts are designed for Codex or another AI agent running from the repository root. Replace placeholders before use.

## General Agent Rules

Use this block at the top of any serious reading session.

```text
You are helping maintain my Obsidian paper reading system. Work from this repository root.

Rules:
- Use the existing note if it exists; do not create duplicates.
- Do not overwrite human-written interpretation without asking.
- Preserve frontmatter fields unrelated to the task.
- Do not commit PDFs, BibTeX exports, Zotero databases, or private notes.
- Keep private research ideas out of public notes unless I explicitly approve.
- Prefer Zotero/Better BibTeX metadata for authors, year, DOI, arXiv, and citation key.
- Use the note's requested depth: skim, standard, deep, or paper-with-code.
- Focus on understanding and research judgment, not generic summary.
```

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
6. Report any metadata ambiguities rather than guessing.
```

## Skim Reading Session

```text
I want to skim this paper with you.

Note: <note path>
PDF or Zotero item: <pdf path or zotero URI>
Time budget: <30|45|60> minutes
My research context: <context>

Please guide an AI-assisted skim:
1. Identify the problem and motivation.
2. State the core idea in one sentence.
3. Explain the method at a high level.
4. Summarize the experiment/evaluation design.
5. Identify the main conclusion and limitations.
6. Tell me whether this deserves standard or deep reading.
7. Update the note at skim depth after we discuss.

Do not spend time on full proofs or implementation unless they are central.
```

## Standard Reading Session

```text
I want to read this paper at standard depth.

Note: <note path>
PDF or Zotero item: <pdf path or zotero URI>
My research context: <context>
Specific questions I care about: <questions>

Please help me understand:
1. problem setting and motivation;
2. prior work and what was missing;
3. method components and assumptions;
4. training/inference or algorithmic procedure;
5. experiments, baselines, metrics, and ablations;
6. evidence quality;
7. limitations and failure modes;
8. connections to my research.

Ask me clarifying questions when needed. Update the note section by section, preserving existing human-written content.
```

## Deep Reading Session

```text
I want to deep-read this paper.

Note: <note path>
PDF or Zotero item: <pdf path or zotero URI>
Why it may be foundational: <reason>
My research context: <context>

Please run a deep reading session:
1. Reconstruct the historical problem context.
2. Identify the key insight that made the paper work.
3. Reconstruct the method carefully.
4. Explain important equations, assumptions, and theorem statements.
5. Evaluate the evidence and limitations like a critical reviewer.
6. Map predecessors, competing lines, and follow-up papers.
7. Extract reusable research patterns.
8. Help me write the note so I can remember the paper months later.

Do not produce a generic summary. Make the note reflect actual understanding.
```

## Paper With Code Session

```text
I want to read and inspect the implementation of this paper.

Note: <note path>
PDF or Zotero item: <pdf path or zotero URI>
Code repository: <repo URL or local path>
Target result or component: <target>
My hardware/software constraints: <constraints>

Please:
1. Summarize the paper's core method.
2. Map paper concepts to code files.
3. Identify training, evaluation, model, data, and config entry points.
4. Document installation and reproduction steps.
5. Estimate what can be reproduced locally.
6. Update the paper-with-code note with a code map and reproduction plan.
7. Do not run expensive experiments without asking.
```

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
1. Review inbox and active reading dashboards.
2. Identify papers that should be queued, archived, or promoted to deep reading.
3. Check for obvious metadata, Zotero, or category problems.
4. Suggest one MOC that should be refreshed.
5. Do not make broad changes without showing the proposed actions first.
```

## Note Finalization

```text
Please finalize this paper note.

Note: <note path>
Intended depth: <skim|standard|deep|paper-with-code>

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

Report remaining gaps.
```