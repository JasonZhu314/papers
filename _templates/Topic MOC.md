---
note_type: moc
title:
topics: []
publish: true
---

# MOC - {{topic}}

## Scope


## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "{{topic}}")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Foundational Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "{{topic}}") AND importance >= 4
SORT year ASC, file.name ASC
```

## Synthesis

-

## Open Questions

-
