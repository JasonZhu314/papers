---
note_type: moc
title: MOC - Scientific Applications
topics:
  - SciML
  - Scientific Applications
publish: true
---

# MOC - Scientific Applications

## Scope

Domain-facing papers where the scientific or engineering application is central.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Scientific Applications")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
