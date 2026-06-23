---
note_type: dashboard
publish: true
---

# Reading Inbox

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND (status = "inbox" OR status = "queued")
SORT date_added DESC, importance DESC, file.name ASC
```
