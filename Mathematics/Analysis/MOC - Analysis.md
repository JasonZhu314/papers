---
note_type: moc
title: MOC - Analysis
topics:
  - Mathematics
  - Analysis
publish: true
---

# MOC - Analysis

## Scope

Real analysis, functional analysis, harmonic analysis, measure theory, Sobolev spaces, spectral theory, and analysis background for PDEs and SciML.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Analysis")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
