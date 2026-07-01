---
note_type: moc
title: MOC - Neural Differential Equations
topics:
  - SciML
  - Neural Differential Equations
publish: true
---

# MOC - Neural Differential Equations

## Scope

Neural ODEs, neural SDEs, universal differential equations, continuous-depth models, and learned dynamics.

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Neural Differential Equations") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Neural Differential Equations")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use this area for papers where differential-equation structure is the main contribution, even if the model is also relevant to general deep learning.

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
