# Skim Reading Prompt

Use this when the goal is a fast, interactive decision: should this paper be ignored, remembered briefly, or promoted to standard/deep reading?

## Starter Prompt

```text
I want to skim this paper interactively with you.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
Time budget: <15|30|45|60> minutes
Learning objective: I am skimming this paper to decide <decision> or understand <X>.
My research context: <context>
Specific question or decision: <question>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Optimize for decision quality, not completeness.
- Help me decide where to spend attention, not just summarize.
- Ask short questions when my goal, background, or decision criterion is unclear.
- Tell me explicitly when to stop, promote, or defer the paper.
- Do not expand background unless it changes the reading decision.

Start by giving me:
1. the fastest reading route through the paper;
2. what to inspect first: abstract, figures, intro, experiments, conclusion, or appendix;
3. the 3-5 questions I should answer before deciding whether to read deeper.
```

## Interactive Reading Prompts

```text
Before I spend more time on <section/figure/table>, tell me what to extract, what can be ignored at skim depth, and what finding would justify promotion to standard reading.
```

```text
I just read the abstract and introduction. What is the actual problem, claim, and likely contribution? Ask me 2 questions to check whether I understood it.
```

```text
I am looking at <figure/table/section>. Tell me what to extract from it and what would make the paper worth a deeper read.
```

```text
Summarize <section> at skim depth. Separate what the authors claim from what they actually show.
```

```text
Here is the decision I think this paper supports: <decision>. Audit it and tell me whether the evidence is enough for skim depth.
```

```text
Checkpoint my understanding: here is my one-sentence summary: <summary>. Correct it and tell me what I am missing.
```

```text
Should I stop, keep this as a skim, or promote it to standard/deep reading? Judge by relevance, novelty, evidence quality, and usefulness to my research.
```

## Final Note Prompt

```text
We have finished the skim. Now generate or update the Obsidian note.

Note: <note path>
Use template: `_templates/Paper - Skim.md`
Today's date: <YYYY-MM-DD>
My final takeaways: <takeaways>
Remaining uncertainty: <uncertainty>
Decision: <stop|standard later|deep later|paper-with-code later>
Taste calibration: <why it matters or not; reusable pattern; promote/not-promote reason>
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable note.
- Preserve any human-written note content unless I explicitly say to replace it.
- Keep the note concise; this is a skim note, not a full reconstruction.
- Mark uncertain points as uncertain instead of inventing details.
- Keep the public paper note limited to material distilled from the paper: problem, claim, evidence signal, limitations, and reading decision.
- Include a concise Taste Calibration section only with public, paper-grounded judgment; keep speculative research ideas private.
- Do not put research ideas, speculative connections, private insights, or unresolved questions in the public paper note.
- If `Private ideas to avoid publishing` is not `none`, create or update a companion private note under `papers/_private/` with `publish: false`; the private note should link back to the public paper note, but the public paper note should not link to the private note.
- Do not write workflow or note-policy instructions into generated notes.
- Set `status: done` only if the skim note is complete; otherwise leave `status: queued` or `reading` and list gaps.
- Set `date_read`, `has_ideas`, `importance`, and `depth` deliberately.
```
