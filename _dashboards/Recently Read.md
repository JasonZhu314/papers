---
note_type: dashboard
publish: true
---

# Recently Read

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND status = "done" AND date_read
SORT date_read DESC, importance DESC
LIMIT 50
```
