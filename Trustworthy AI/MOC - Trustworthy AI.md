---
note_type: moc
title: MOC - Trustworthy AI
topics:
  - Trustworthy AI
publish: true
---

# MOC - Trustworthy AI

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Trustworthy AI")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
