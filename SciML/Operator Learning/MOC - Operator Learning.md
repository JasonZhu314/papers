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

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Operator Learning")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Foundational Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Operator Learning") AND importance >= 4
SORT year ASC, file.name ASC
```

## Synthesis

- Treat DeepONet and neural operators as part of the broader operator learning family.
- Use tags to distinguish `deeponet`, `fno`, `gno`, `transformer-neural-operator`, `koopman`, and `operator-theory`.
