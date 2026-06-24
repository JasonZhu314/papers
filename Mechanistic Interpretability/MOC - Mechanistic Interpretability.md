---
note_type: moc
title: MOC - Mechanistic Interpretability
topics:
  - Mechanistic Interpretability
publish: true
---

# MOC - Mechanistic Interpretability

## Scope

Work that tries to understand, localize, explain, or control model internals. Alignment, safety, monitoring, and robustness live here when the core motivation is applying understanding of AI systems.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Mechanistic Interpretability")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
