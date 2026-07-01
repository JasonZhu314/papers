# Paper With Code Prompt

Use this for an interactive reading session where implementation, reproducibility, or code reuse matters.

## Starter Prompt

```text
I want to read this paper and inspect its implementation with you.

Note: <note path>
PDF or Zotero item: <pdf path or Zotero URI>
Code repository: <repo URL or local path>
Target result or component: <target>
My hardware/software constraints: <constraints>
My research context: <context>

Rules for this session:
- Do not generate or fill the final Obsidian note yet.
- Do not overwrite existing note content during the reading conversation.
- If I explicitly ask you to edit files, only make minimal lifecycle/metadata edits such as `status: reading`; otherwise keep all work in the conversation.
- Do not run expensive experiments, install dependencies, download large data, or modify external repos without asking.
- First understand the paper. Then map concepts to code. Then discuss reproduction.
- Distinguish paper claims from what the code actually supports.

Start by giving me:
1. a reading route through the paper;
2. a code-inspection route through the repository;
3. likely reproduction risks;
4. the first questions I should answer before running anything.
```

## Interactive Reading Prompts

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
Private ideas to avoid publishing: <private ideas or none>

Rules:
- Now, and only now, write the durable note.
- Base the note on our paper discussion and code inspection.
- Preserve any human-written note content unless I explicitly say to replace it.
- Separate paper method, code map, environment, reproduction plan, and actual run log.
- Do not invent commands or results. Mark unknowns and blocked items clearly.
- Keep private or unpublished ideas out of public notes unless I explicitly approve them.
- Set `status: done` only if paper understanding and implementation/reproduction status are clear enough for this depth; otherwise leave `status: reading` and list gaps.
- Set `date_read`, `has_ideas`, `importance`, `depth`, `implementation_status`, and `reproduction_status` deliberately.
```
