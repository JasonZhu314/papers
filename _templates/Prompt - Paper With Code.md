# Paper With Code Prompt

Use this for an interactive reading session where implementation, reproducibility, or code reuse matters.

## Starter Prompt

```text
I want to read this paper and inspect its implementation with you.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
Code repository: <repo URL or local path>
Learning objective: I am reading this paper/code to understand or reuse <X> so that I can <Y>.
Target result or component: <target>
My hardware/software constraints: <constraints>
My research context: <context>
Relevant background I am weak on: <weak background>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Do not run expensive experiments, install dependencies, download large data, or modify external repos without asking.
- First understand the paper. Then map concepts to code. Then discuss reproduction.
- Distinguish paper claims from what the code actually supports.
- Use objective-driven passes: orient me to the paper's load-bearing method, audit my understanding, then inspect only the code paths needed for the target.
- Do not summarize the repository broadly when a narrow code map is enough.
- Teach background on demand only when it affects implementation or reproduction.

Start by giving me:
1. a reading route through the paper;
2. a code-inspection route through the repository;
3. likely reproduction risks;
4. the first questions I should answer before running anything.
```

## Interactive Reading Prompts

```text
I am about to read <paper section>. Give me a reading guide focused on what must later be found in code: objects, equations, algorithms, configs, losses, data flow, and evaluation claims.
```

```text
I finished <paper section>. Explain the method and identify what code files or modules should implement it.
```

```text
Inspect <file/function/config>. Map it back to the paper's concepts, equations, and experimental claims.
```

```text
What should I verify before trying to reproduce <result>? List data, checkpoint, config, hardware, command, metric, and expected runtime.
```

```text
Here is my understanding of the implementation: <summary>. Find mismatches between the paper and code.
```

```text
Here is the result/component I care about: <target>. Tell me the minimal paper sections and code paths I need to inspect, and what I can ignore for now.
```

```text
Evaluate whether this repository is reusable for my work. Separate easy reuse, fragile parts, missing details, and likely engineering cost.
```

```text
Design a minimal reproduction or sanity check that is cheap enough to run locally. Do not run it until I approve.
```

## Final Note Prompt

```text
We have finished the paper-with-code reading. Now generate or update the Obsidian note.

Note: <note path>
Use template: `_templates/Paper - Paper With Code.md`
Today's date: <YYYY-MM-DD>
My final takeaways: <takeaways>
Reproduction status: <not-started|planned|partial|reproduced|blocked>
Implementation status: <not-started|inspected|usable|fragile|blocked>
Taste calibration: <why it mattered; reusable paper/code pattern; fragility; what to test before building on it>
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable note.
- Base the note on our paper discussion and code inspection.
- Preserve any human-written note content unless I explicitly say to replace it.
- Separate paper method, code map, environment, reproduction plan, and actual run log.
- Do not invent commands or results. Mark unknowns and blocked items clearly.
- Keep the public paper note limited to material distilled from the paper/code: method, evidence, implementation facts, reproduction status, limitations, and neutral critique.
- Include a Taste Calibration section with public, paper-grounded judgment about influence, reusable patterns, and paper-to-code fragility.
- Do not put research ideas, speculative connections, private insights, or unresolved questions in the public paper note.
- If `Private ideas to avoid publishing` is not `none`, create or update a companion private note under `papers/_private/` with `publish: false`; the private note should link back to the public paper note, but the public paper note should not link to the private note.
- Do not write workflow or note-policy instructions into generated notes.
- Set `status: done` only if paper understanding and implementation/reproduction status are clear enough for this depth; otherwise leave `status: reading` and list gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, `implementation_status`, and `reproduction_status` deliberately.
```
