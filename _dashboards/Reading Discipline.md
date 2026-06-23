---
note_type: dashboard
publish: true
---

# Reading Discipline

## Completed Notes

```dataview
TABLE WITHOUT ID file.link AS Paper, date_read AS Read, depth AS Depth, topics AS Topics, importance AS Importance
FROM ""
WHERE note_type = "paper" AND publish != false AND status = "done" AND date_read
SORT date_read DESC
LIMIT 100
```

## Deep Reading

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, status AS Status, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND (depth = "deep" OR depth = "paper-with-code")
SORT status ASC, importance DESC, date_read DESC
```
