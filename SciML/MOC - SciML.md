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

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "SciML") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "SciML")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Foundational Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "SciML") AND importance >= 4
SORT year ASC, file.name ASC
```

## Synthesis

- Operator learning, physics-informed learning, and neural differential equations should be kept distinct unless the paper explicitly bridges them.
- Place application-heavy papers by the scientific domain if the domain problem is the main reason to remember them.

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
