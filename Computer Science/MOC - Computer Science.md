---
note_type: moc
title: MOC - Computer Science
topics:
  - Computer Science
publish: true
---

# MOC - Computer Science

## Scope

Non-AI computer science papers: algorithms, complexity, programming languages, distributed systems, databases, security, cryptography, and software engineering.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Computer Science")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
