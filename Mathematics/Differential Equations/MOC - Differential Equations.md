---
note_type: moc
title: MOC - Differential Equations
topics:
  - Mathematics
  - Differential Equations
publish: true
---

# MOC - Differential Equations

## Scope

ODEs, PDEs, dynamical systems, stability theory, optimal control, numerical PDE interfaces, and calculus of variations.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Differential Equations")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
