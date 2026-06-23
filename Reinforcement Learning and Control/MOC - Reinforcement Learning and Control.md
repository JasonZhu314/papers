---
note_type: moc
title: MOC - Reinforcement Learning and Control
topics:
  - Reinforcement Learning and Control
publish: true
---

# MOC - Reinforcement Learning and Control

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Reinforcement Learning and Control")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
