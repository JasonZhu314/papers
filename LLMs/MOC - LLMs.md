---
note_type: moc
title: MOC - LLMs
topics:
  - LLMs
publish: true
---

# MOC - LLMs

## Scope

LLM papers organized by lifecycle: pretraining, post-training, inference, capabilities, retrieval and memory, evaluation, and interpretability.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "LLMs")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use folders for lifecycle placement.
- Use tags for details such as `pretraining`, `sft`, `rlhf`, `dpo`, `inference`, `kv-cache`, `rag`, `agent`, or `long-context`.
