# Standard Reading Prompt

Use this for an interactive reading session where the goal is to understand the paper well enough to cite, compare, and reuse the main idea.

## Starter Prompt

```text
I want to read this paper interactively at standard depth.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
Learning objective: I am reading this paper to understand <X> so that I can <Y>.
My research context: <context>
Specific questions I care about: <questions>
Relevant background I already know: <background>
Relevant background I am weak on: <weak background>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Use objective-driven passes: orient me before close reading, let me read the load-bearing parts myself, then audit my understanding.
- Guide my attention section by section. Tell me what to focus on, what can be skimmed, and what deserves slow reading.
- Help me clarify concepts, equations, figures, and experiments when I ask.
- Prompt me to think critically instead of only summarizing.
- Do not give a full substitute summary for important sections unless I explicitly ask. Prefer a reading map, checkpoints, and targeted explanations.
- Use modes explicitly when helpful: orientation, explanation, audit, evidence, and idea.

Start by giving me:
1. a short reading route through the paper;
2. the key objects I should track while reading;
3. the likely contribution and the evidence I should look for;
4. the first section I should read in orientation mode;
5. questions I should keep in mind during the first pass.
```

## Interactive Reading Prompts

```text
I am about to read <section>. Before I read closely, give me a reading guide.

Please include:
1. section goal;
2. why it matters for the paper's main claim;
3. key objects, notation, equations, algorithms, figures, or tables to track;
4. slow-read targets;
5. skimmable parts;
6. missing prerequisites I need for this section only;
7. 3-5 checkpoints I should answer after reading;
8. common traps or likely overclaims.

Do not give a full substitute summary. Give me a map for active reading.
```

```text
I finished <section>. Extract the problem, claim, and assumptions from it. Then ask me 2 questions that test whether I really understood the section.
```

```text
Explain <concept/equation/algorithm/figure> in this paper. Start intuitive, then give the precise version, then tell me why it matters for the main claim.
```

```text
What should I focus on in <next section>? Tell me what to read slowly, what to skim, and what questions to answer.
```

```text
Here is my current understanding: <summary>. Critique it, correct it, and identify the most important missing piece.
```

```text
I finished <section>. Here is my understanding: <summary>.

Please correct misunderstandings, identify what I missed, ask me 2-3 questions that test real understanding, and tell me whether to move on or reread a specific part.
```

```text
Evaluate the evidence in <experiment/table/ablation>. What claim does it support, what does it not support, and what would a skeptical reviewer ask?
```

```text
Spark ideas from this section. Give me concrete research directions, possible ablations, harder settings, or connections to my current work. Mark speculative ideas clearly.
```

## Final Note Prompt

```text
We have finished the standard reading. Now generate or update the Obsidian note.

Note: <note path>
Use template: `_templates/Paper - Standard.md`
Today's date: <YYYY-MM-DD>
My final takeaways: <takeaways>
My unresolved questions: <questions>
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable note.
- Base the note on our reading conversation plus the paper, not on a generic first-pass summary.
- Preserve any human-written note content unless I explicitly say to replace it.
- Separate the paper's claims from my interpretation and criticism.
- Mark uncertain points as uncertain instead of inventing details.
- Keep the public paper note limited to material distilled from the paper: problem, method, claims, evidence, limitations, and neutral critique.
- Do not put research ideas, speculative connections, private insights, or unresolved questions in the public paper note.
- If `Private ideas to avoid publishing` is not `none`, create or update a companion private note under `papers/_private/` with `publish: false`; the private note should link back to the public paper note, but the public paper note should not link to the private note.
- Do not write workflow or note-policy instructions into generated notes.
- Set `status: done` only if the note is complete for standard depth; otherwise leave `status: reading` and list the remaining gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, and bibliographic metadata deliberately.
```
