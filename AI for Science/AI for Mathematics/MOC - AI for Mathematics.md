---
note_type: moc
title: MOC - AI for Mathematics
topics:
  - AI for Science
  - AI for Mathematics
publish: true
---

# MOC - AI for Mathematics

## Scope

AI systems for theorem proving, formalization, conjecture generation, mathematical discovery, automated problem solving, and human-AI mathematical collaboration.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "AI for Mathematics")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
