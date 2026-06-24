---
note_type: moc
title: MOC - AI for Science
topics:
  - AI for Science
publish: true
---

# MOC - AI for Science

## Scope

Influential work that uses AI to accelerate scientific discovery, automate scientific reasoning, or build AI systems for domain science.

This is separate from `SciML`: SciML is method-first for scientific computing, PDEs, operators, inverse problems, and numerical surrogates. AI for Science is discovery-first and domain-facing.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "AI for Science")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
