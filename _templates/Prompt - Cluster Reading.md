# Cluster Reading Prompt

Use this for interactive contrastive reading of several related papers where the goal is to understand a design space, lineage, or tradeoff.

## Starter Prompt

```text
I want to read this cluster of papers interactively.

Cluster note: <cluster note path>
Papers:
- <paper 1 note/PDF/Zotero item>
- <paper 2 note/PDF/Zotero item>
- <paper 3 note/PDF/Zotero item>

Learning objective: I am reading this cluster to understand <X> so that I can <Y>.
Possible cluster type: <paired contrast|anchor plus extension|same problem different solution|version sequence|historical lineage|benchmark cluster|unknown>
My research context: <context>
Specific decision or question: <decision/question>
Relevant background I already know: <background>
Relevant background I am weak on: <weak background>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Use contrastive reading, not linear multi-paper summarization.
- Help me choose an anchor paper and comparison axes before deep reading.
- Skim all papers first, then read the anchor carefully, then read the others by delta.
- Tell me when papers are not comparable or when a cluster should be split.
- Teach background on demand only when it affects the comparison.
- Keep public cluster notes limited to paper-derived synthesis; put private ideas in a companion private note if needed.

Start by giving me:
1. the likely cluster type;
2. the best anchor paper and why;
3. the comparison axes to fill while reading;
4. the fastest skim route across all papers;
5. which paper or section I should read first in orientation mode.
```

## Interactive Reading Prompts

```text
Before I read this cluster closely, classify the relationship among the papers and propose comparison axes. Tell me which paper should be the anchor.
```

```text
I skimmed <paper>. Extract only what matters for the cluster: problem, claim, method sketch, evidence, limitation, and why it belongs here.
```

```text
I am about to read the anchor paper <paper>. Give me a reading guide: load-bearing sections, key objects, slow-read targets, skimmable parts, and checkpoints.
```

```text
I finished the anchor paper. Here is my understanding: <summary>. Audit it and identify the vocabulary or mechanism I need before comparing the other papers.
```

```text
Now read <paper> by delta against the anchor. What changed, why did it change, what limitation does it claim to fix, and does the evidence support that?
```

```text
Fill or revise the comparison axes for these papers. Mark uncertain cells as uncertain instead of inventing details.
```

```text
Evaluate whether the experiments are actually comparable across the cluster. What claims can and cannot be made from the comparison?
```

```text
Here is my cluster synthesis: <summary>. Critique it, correct overclaims, and tell me which individual paper deserves deeper reading.
```

```text
Spark ideas from this cluster. Separate paper-derived synthesis, conservative extensions, risky ideas, and private unpublished directions.
```

## Final Note Prompt

```text
We have finished the cluster reading. Now generate or update the Obsidian cluster note.

Cluster note: <cluster note path>
Use template: `_templates/Paper Cluster - Contrastive Reading.md`
Today's date: <YYYY-MM-DD>
My final synthesis: <synthesis>
Papers that need individual full notes: <papers or none>
Taste calibration: <why the line mattered; what survived; what was repaired or abandoned; best problem framing>
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable cluster note.
- Base the note on our contrastive reading conversation plus the papers, not on generic summaries.
- Preserve any human-written note content unless I explicitly say to replace it.
- Separate paper-derived synthesis from my interpretation and criticism.
- Mark uncertain points as uncertain instead of inventing details.
- Keep the public cluster note limited to paper-derived synthesis: shared problem, comparison, evidence, limitations, and reading decision.
- Include a Taste Calibration section with public, paper-grounded judgment about the lineage, durable abstractions, and weak points.
- Do not put research ideas, speculative connections, private insights, or unresolved questions in the public cluster note.
- If `Private ideas to avoid publishing` is not `none`, create or update a companion private note under `papers/_private/` with `publish: false`; the private note should link back to the public cluster note, but the public cluster note should not link to the private note.
- Do not write workflow or note-policy instructions into generated notes.
- Set `status: done` only if the cluster note is complete for the chosen objective; otherwise leave `status: reading` and list remaining gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, `papers`, and `anchor_paper` deliberately.
```
