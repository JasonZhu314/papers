---
note_type: moc
title: MOC - PDE Solvers and Surrogates
topics:
  - SciML
  - PDE Solvers and Surrogates
publish: true
---

# MOC - PDE Solvers and Surrogates

## Scope

Learned solvers, surrogate models, mesh-aware methods, mesh-free methods, time-stepping models, and multiscale methods.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "PDE Solvers and Surrogates")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
