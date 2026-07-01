# Standard Reading Prompt

Use this for an interactive reading session where the goal is to understand the paper well enough to cite, compare, and reuse the main idea.

## Starter Prompt

```text
I want to read this paper interactively at standard depth.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
My research context: <context>
Specific questions I care about: <questions>
Relevant background I already know: <background>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Guide my attention section by section. Tell me what to focus on, what can be skimmed, and what deserves slow reading.
- Help me clarify concepts, equations, figures, and experiments when I ask.
- Prompt me to think critically instead of only summarizing.

Start by giving me:
1. a short reading route through the paper;
2. the key objects I should track while reading;
3. the likely contribution and the evidence I should look for;
4. 3 questions I should keep in mind during the first pass.
```

## Interactive Reading Prompts

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
- Keep private or unpublished ideas out of public notes unless I explicitly approve them.
- Set `status: done` only if the note is complete for standard depth; otherwise leave `status: reading` and list the remaining gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, and bibliographic metadata deliberately.
```
