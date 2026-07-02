# Deep Reading Prompt

Use this for a multi-session, interactive reconstruction of a foundational or thesis-central paper.

## Starter Prompt

```text
I want to deep-read this paper with you.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
Learning objective: I am deep-reading this paper to understand <X> so that I can reconstruct/use/criticize <Y>.
Why this may be foundational: <reason>
My research context: <context>
What I want to be able to reconstruct later: <target>
Relevant background I already know: <background>
Relevant background I am weak on: <weak background>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Treat this as an interactive seminar, not a summary task.
- Use objective-driven passes: orient me before close reading, make me reconstruct the load-bearing parts, then audit my reconstruction.
- Push me to reconstruct definitions, assumptions, equations, proofs, algorithms, and evidence in my own words.
- When something is important, ask me to explain it back before moving on.
- Teach background on demand, but only as much as needed to unlock the paper.
- Do not let summaries replace reconstruction of central sections.

Start by giving me:
1. a multi-pass reading plan;
2. the central objects, assumptions, and claims to track;
3. likely hard sections and why they matter;
4. which sections need orientation, reconstruction, evidence, or audit mode;
5. a first set of deep-reading questions for the introduction and method overview.
```

## Interactive Reading Prompts

```text
I am about to read <section>. Give me a deep-reading guide: section goal, load-bearing definitions/equations/claims, prerequisites, what to reconstruct after reading, and common traps.
```

```text
I finished <section>. Reconstruct the argument with me: definitions, assumptions, claim, mechanism, and why the section is needed.
```

```text
Explain <equation/theorem/algorithm>. Give the intuition, the formal meaning, the role in the paper, and what would break if this assumption changed.
```

```text
Ask me Socratic questions about <section>. Do not answer immediately; help me discover the key idea.
```

```text
Here is my reconstruction of the method: <reconstruction>. Identify gaps, hidden assumptions, and places where I am confusing implementation with the core idea.
```

```text
I think I understand <section>. Ask me 3 Socratic questions that would reveal whether I really understand the mechanism, assumptions, and evidence.
```

```text
Review the evidence like a critical reviewer. Which claims are actually supported? Which claims are plausible but not established?
```

```text
Map this paper into the field: predecessors, competing lines, follow-up work, and what research pattern became reusable.
```

```text
Generate research ideas from this paper, but separate conservative extensions, risky ideas, and private unpublished directions.
```

## Final Note Prompt

```text
We have finished the deep reading. Now generate or update the Obsidian note.

Note: <note path>
Use template: `_templates/Paper - Deep Reading.md`
Today's date: <YYYY-MM-DD>
My final reconstruction: <reconstruction>
My unresolved questions: <questions>
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable note.
- The note should preserve understanding, not transcript fragments.
- Base the note on our interactive reconstruction plus the paper.
- Preserve any human-written note content unless I explicitly say to replace it.
- Separate formal claims, evidence, limitations, and my interpretation.
- Mark uncertain points as uncertain instead of inventing details.
- Keep the public paper note limited to material distilled from the paper: problem, method, claims, evidence, limitations, and neutral critique.
- Do not put research ideas, speculative connections, private insights, or unresolved questions in the public paper note.
- If `Private ideas to avoid publishing` is not `none`, create or update a companion private note under `papers/_private/` with `publish: false`; the private note should link back to the public paper note, but the public paper note should not link to the private note.
- Do not write workflow or note-policy instructions into generated notes.
- Set `status: done` only if the deep note is complete enough to reconstruct the paper later; otherwise leave `status: reading` and list the remaining gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, and bibliographic metadata deliberately.
```
