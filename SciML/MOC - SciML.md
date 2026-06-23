---
note_type: moc
title: MOC - SciML
topics:
  - SciML
publish: true
---

# MOC - SciML

## Scope

Scientific machine learning papers, especially methods for PDEs, operator learning, scientific surrogates, inverse problems, and real-world scientific applications.

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "SciML")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Foundational Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "SciML") AND importance >= 4
SORT year ASC, file.name ASC
```

## Synthesis

- Operator learning, physics-informed learning, and neural differential equations should be kept distinct unless the paper explicitly bridges them.
- Place application-heavy papers by the scientific domain if the domain problem is the main reason to remember them.
