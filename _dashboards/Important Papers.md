---
note_type: dashboard
publish: true
---

# Important Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND importance >= 4
SORT importance DESC, year ASC, file.name ASC
```
