---
note_type: dashboard
publish: true
---

# Reading Now

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND status = "reading"
SORT importance DESC, date_added DESC, file.name ASC
```
