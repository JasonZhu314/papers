---
note_type: moc
title: MOC - Numerical Analysis
topics:
  - Mathematics
  - Numerical Analysis
publish: true
---

# MOC - Numerical Analysis

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Numerical Analysis")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
