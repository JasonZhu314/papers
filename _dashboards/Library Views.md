---
note_type: dashboard
publish: true
---

# Library Views

Generated reference views. Do not maintain queues here; use `_dashboards/This Week.md` for reading order.

## Reading Now

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND status = "reading"
SORT importance DESC, date_added DESC, file.name ASC
```

## Queued

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND status = "queued"
SORT importance DESC, date_added DESC, file.name ASC
```

## Inbox

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND status = "inbox"
SORT date_added DESC, importance DESC, file.name ASC
```

## Recently Read

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND status = "done" AND date_read
SORT date_read DESC, importance DESC
LIMIT 50
```

## Important Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND importance >= 4
SORT importance DESC, year ASC, file.name ASC
```

## Ideas Extracted

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, depth AS Depth, importance AS Importance
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND has_ideas = true
SORT importance DESC, date_read DESC, file.name ASC
```

## Deep Reading

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, topics AS Topics, status AS Status, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND (depth = "deep" OR depth = "paper-with-code")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, date_read DESC
```
