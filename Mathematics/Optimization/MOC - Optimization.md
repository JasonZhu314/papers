---
note_type: moc
title: MOC - Mathematical Optimization
topics:
  - Mathematics
  - Mathematical Optimization
publish: true
---

# MOC - Mathematical Optimization

## Scope

Optimization as mathematics and numerical analysis: convex and nonconvex optimization, variational methods, first-order and second-order methods, stochastic optimization, optimal transport, distributed optimization, convergence rates, stability, and complexity.

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Mathematical Optimization") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Mathematical Optimization")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Boundary With AI Optimizers

Put Adam, AdamW, Lion, Muon, Shampoo, Sophia, learned optimizers, optimizer scaling studies, and neural-network training-stability papers under AI-facing folders unless the mathematical analysis is the main reason to remember the paper.
## Synthesis

- Working synthesis starts here once paper notes in this topic contain real reading content.

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
