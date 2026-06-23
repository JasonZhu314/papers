---
note_type: moc
title: MOC - SciML Theory
topics:
  - SciML
  - SciML Theory
publish: true
---

# MOC - SciML Theory

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "SciML Theory")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
