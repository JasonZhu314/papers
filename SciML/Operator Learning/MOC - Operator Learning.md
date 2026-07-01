---
note_type: moc
title: MOC - Operator Learning
topics:
  - SciML
  - Operator Learning
publish: true
---

# MOC - Operator Learning

## Scope

Methods that learn mappings between function spaces, solution operators, or dynamics operators.

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Operator Learning") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Operator Learning")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Foundational Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Operator Learning") AND importance >= 4
SORT year ASC, file.name ASC
```

## Synthesis

- Treat DeepONet and neural operators as part of the broader operator learning family.
- Use tags to distinguish `deeponet`, `fno`, `gno`, `transformer-neural-operator`, `koopman`, and `operator-theory`.

## Field Map

- Core problems:
- Method families:
- Evaluation standards:
- Key assumptions:

## Comparison Axes

- What each paper claims:
- Evidence used for the claim:
- Where the method fails:
- What transfers to current research:

## Open Questions

-

## Synthesis Log

| Date | Paper or Cluster | Update |
| --- | --- | --- |
