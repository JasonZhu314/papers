---
note_type: dashboard
publish: true
---

# Ideas Extracted

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance
FROM ""
WHERE note_type = "paper" AND publish != false AND has_ideas = true
SORT importance DESC, date_read DESC, file.name ASC
```
