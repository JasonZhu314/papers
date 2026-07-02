# Paper Reading And Research Methodology

This guide describes how to select papers, choose reading depth, read actively, and turn reading into research progress.

## The Goal Of Reading

The goal is not to collect summaries. The goal is to build judgment.

A useful paper note should help you remember:

- the problem;
- the motivation;
- the main idea;
- the method;
- the evidence;
- the assumptions;
- the limitations;
- the relationship to prior and follow-up work;
- what the paper changes about your own research taste.

## Selection Funnel

Use a funnel instead of a completionist reading list.

### Tier 1: Must Read Deeply

Read deeply if the paper is:

- foundational for your research area;
- repeatedly cited by papers you care about;
- directly relevant to your thesis direction;
- technically reusable in your own work;
- a field-shaping paper that changed what people attempted;
- a paper whose assumptions or limitations determine whether your idea is viable.

### Tier 2: Read Normally

Use standard reading if the paper is:

- relevant to a current project;
- a strong baseline or competing method;
- a useful survey node in the citation graph;
- an implementation or evaluation reference;
- important but not central enough for full reconstruction.

### Tier 3: Skim

Skim if the paper is:

- recent and possibly relevant;
- cited once in a paper you read;
- adjacent to your field;
- likely useful only for positioning;
- a quick check for novelty or related work.

### Tier 4: Archive Or Ignore

Archive or ignore if:

- the core problem is not relevant;
- the method is incremental and not useful to you;
- the evidence is weak and the idea is not reusable;
- a better survey or follow-up paper supersedes it;
- reading it is procrastination disguised as diligence.

## Selection Questions

Before reading, answer:

1. Why might this paper matter to my research?
2. What decision will this paper help me make?
3. Is this paper foundational, competitive, contextual, or merely adjacent?
4. What depth is justified?
5. What would make me stop reading after 10 minutes?

If you cannot answer these, keep the paper in Zotero only or mark the note `inbox`.

## Reading Depths

### Skim

Time budget: 15-60 minutes.

Goal: know whether the paper matters and remember the main point.

Capture:

- problem;
- one-sentence contribution;
- method sketch;
- evaluation setup;
- main result;
- limitations;
- whether to read deeper.

Do not reconstruct proofs or implementation details unless they are the point.

### Standard

Time budget: 1-3 hours.

Goal: understand enough to compare, cite, and use the paper.

Capture:

- problem setup;
- assumptions;
- method components;
- training or algorithmic procedure;
- baselines;
- metrics;
- what evidence supports each claim;
- relationship to prior work;
- limitations and failure modes.

### Deep

Time budget: multiple sessions.

Goal: internalize a foundational or thesis-central paper.

Capture:

- historical problem context;
- the key insight;
- method reconstruction;
- mathematical structure;
- implementation details;
- evidence quality;
- hidden assumptions;
- why the paper succeeded;
- what later work changed;
- reusable research patterns.

### Paper With Code

Use when implementation matters.

Capture:

- repository link;
- code map;
- setup commands;
- model files;
- training/evaluation scripts;
- expected results;
- reproduction log;
- deviations from the paper;
- implementation insights.

## Efficient Learning Workflow

Do not measure paper reading like novel reading. A paper is not read linearly for total comprehension; it is mined for a purpose.

The useful metric is:

> How much did this reading reduce my uncertainty about a research question?

Before reading, write one sentence:

> I am reading this paper to understand `<X>` so that I can `<Y>`.

Examples:

- I am reading this paper to decide whether the method is relevant to my current project.
- I am reading this paper to learn the background needed for a cluster of future papers.
- I am reading this paper to compare against a baseline.
- I am reading this paper to extract one implementable idea.

The objective determines what deserves slow reading and what can be compressed.

### Objective-Driven Passes

Use this loop for standard and deep readings:

1. **Orient.** Identify the problem, claimed contribution, section structure, key figures, and what evidence would make the claim believable.
2. **Predict.** Before reading details, ask what should be true if the paper's claim is correct.
3. **Close read.** Read slowly only around load-bearing material: problem setup, main equations, algorithm, key figures, experiment tables, ablations, assumptions, and limitations.
4. **Explain.** Restate the method in your own words before asking for a summary.
5. **Critique.** Ask what is weak, missing, overclaimed, or dependent on hidden assumptions.
6. **Connect.** Write what changes in your research model, implementation plan, or future reading queue.

This is more efficient than trying to understand every sentence at equal depth.

### AI-Assisted Reading Loop

Use an AI agent as a reading scaffold, not as a substitute reader.

For each important section:

1. **Pre-read guidance.** Ask what the section is trying to establish, what to focus on, what to skim, and what questions to answer after reading.
2. **Your close read.** Read the load-bearing paragraphs, equations, figures, and tables yourself.
3. **Post-read audit.** State your understanding and ask the agent to critique it.
4. **Targeted repair.** Ask for explanations only for concepts, equations, or assumptions that block understanding.
5. **Evidence check.** Ask what claim the section supports and what a skeptical reviewer would question.

Good prompt:

```text
I am about to read <section>. Before I read closely, give me a reading guide.

My background: <what I know / what I am weak on>
My goal for this paper: <why I care>

Please structure the guide as:
1. Section goal: what this section is trying to establish.
2. Why it matters: how it supports the paper's main claim.
3. Key objects: notation, variables, algorithms, figures, or equations I must track.
4. Slow-read targets: equations, paragraphs, figures, or assumptions I should read carefully.
5. Skimmable parts: material that is background, routine, or less important.
6. Prerequisites: explain only the missing background needed for this section.
7. Reading checkpoints: 3-5 questions I should be able to answer after reading.
8. Common traps: likely misunderstandings or places where the paper may overstate something.

Do not give a full substitute summary. Give me a map for active reading.
```

Post-read prompt:

```text
I finished <section>. Here is my understanding: <summary>.

Please:
1. correct misunderstandings;
2. identify what I missed;
3. ask me 2-3 questions that test real understanding;
4. tell me whether I should move on, reread a part, or inspect a figure/equation more carefully.
```

### AI Interaction Modes

Use different modes deliberately:

- **Orientation mode:** guide attention before reading.
- **Explanation mode:** explain a concept, equation, figure, or algorithm after a blocker appears.
- **Audit mode:** critique my understanding after I summarize.
- **Evidence mode:** evaluate whether experiments, ablations, or theory support the claim.
- **Idea mode:** only after understanding, discuss research connections, possible extensions, and private ideas.

Avoid using summary mode as the default for important papers. If a section contains a claim you might cite, implement, extend, or criticize, read the load-bearing parts yourself.

### Background On Demand

Do not learn all prerequisites upfront. Learn only the background needed to unlock the current paper or a cluster of future papers.

Go deep on background when:

- the concept recurs across many papers;
- it changes how you interpret the method;
- it affects whether your own research idea is viable;
- you need it to understand the central equations or experiments.

Let the AI compress background when:

- it appears only once;
- it is routine field positioning;
- it is not needed for the main claim;
- it would distract from the current reading objective.

### Realistic Time Calibration

The time budgets above are targets for mature familiarity, not requirements. Reading gets faster after the background stack becomes reusable.

Realistic pattern:

- First paper in a new technical area: 4-8 hours.
- Central paper with substantial background learning: 4-8 hours or multiple sessions.
- Related paper using now-familiar concepts: 2-4 hours.
- Peripheral but relevant paper: 45-90 minutes.
- Relevance skim: 15-30 minutes.

Slow first readings are not failure if they create reusable vocabulary, concepts, and judgment for future papers.

## How To Read A Paper

### Pass 0: Triage

Read title, abstract, figures, conclusion, and introduction skim.

Decide:

- stop;
- skim;
- standard;
- deep;
- paper-with-code.

### Pass 1: Problem And Claim

Identify:

- what problem is being solved;
- why the problem matters;
- what the paper claims is new;
- what evidence would be needed for the claim to be convincing.

### Pass 2: Method

Identify:

- inputs and outputs;
- objective or loss;
- architecture or algorithm;
- assumptions;
- training/inference procedure;
- where the actual novelty lies.

For mathematical papers, separate theorem statements from proof techniques. For applied ML papers, separate model architecture from evaluation protocol.

### Pass 3: Evidence

Ask:

- Are the baselines strong?
- Are the metrics appropriate?
- Are ablations sufficient?
- Does the experiment isolate the claimed contribution?
- Are results robust across settings?
- What would a skeptical reviewer object to?

### Pass 4: Field Position

Map:

- predecessors;
- contemporary alternatives;
- follow-up work;
- what this paper made easier;
- what this paper failed to solve.

### Pass 5: Personal Synthesis

Write:

- what you should remember in one month;
- what idea it triggers;
- how it changes your mental model;
- whether it affects your research direction.

## What To Focus On By Paper Type

### Foundational ML / AI

Focus on:

- the simplifying abstraction;
- why it scaled;
- what assumptions later became invisible;
- what follow-up work reused.

### SciML / Neural Operators

Focus on:

- problem class;
- operator or solver being learned;
- discretization assumptions;
- geometry/domain handling;
- generalization across resolutions, parameters, and PDE families;
- error, stability, and physical consistency;
- comparison to numerical methods.

### Numerical Analysis / Mathematics

Focus on:

- definitions;
- theorem statements;
- assumptions;
- proof strategy;
- examples and counterexamples;
- what technique can be reused;
- relationship to computation.

### LLM Papers

Focus on:

- lifecycle stage: pretraining, post-training, inference, evaluation, or capability;
- data and compute assumptions;
- training objective;
- evaluation reliability;
- scaling behavior;
- failure modes;
- whether the paper teaches a reusable mechanism or only reports a system.

### Mechanistic Interpretability / Safety

Focus on:

- model and setting;
- interpretability object: circuit, feature, direction, probe, behavior;
- intervention strength;
- causal evidence;
- safety implication;
- whether claims generalize beyond the studied model.

## Evidence Quality Checklist

A paper is more trustworthy when:

- the main claim is precise;
- baselines are strong and current;
- ablations target the claimed mechanism;
- negative results are discussed;
- datasets and metrics match the intended use;
- the method is compared under fair compute and tuning budgets;
- limitations are concrete.

A paper is weaker when:

- the contribution is mostly naming;
- baselines are stale;
- improvements are small and unexplained;
- experiments do not isolate the idea;
- claims are broader than evidence;
- code and details are insufficient for reproduction.

## Idea Extraction

After reading, ask:

1. What problem did this paper make visible?
2. What assumption seems unnecessarily restrictive?
3. What method could transfer to SciML, Neural Operators, or computational mathematics?
4. What evaluation is missing?
5. What would fail in a harder setting?
6. What would happen if the key idea were combined with another line of work?
7. What would a simpler version look like?

If the answer is concrete and potentially useful, set `has_ideas: true`. Put private or unpublished ideas in `_private/` or `publish: false` notes.

## Reading Discipline

Use a weekly rhythm:

- 3-5 skim papers for breadth;
- 1 standard paper for active project relevance;
- 0-1 deep paper for foundations.

This is a guideline, not a quota. Depth should follow research need.

## Completion Criteria

A skim note is complete when you can explain the paper in 60 seconds.

A standard note is complete when you can compare it to a related method and cite it accurately.

A deep note is complete when you can reconstruct the core idea without looking and explain why the paper mattered.

A paper-with-code note is complete when the implementation path and reproduction status are clear.
