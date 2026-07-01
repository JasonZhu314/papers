---
note_type: moc
title: MOC - Optimization for Deep Learning
topics:
  - Foundations
  - Optimization for Deep Learning
publish: true
---

# MOC - Optimization for Deep Learning

## Scope

Optimizer and training-method papers whose main purpose is understanding or improving neural-network training: SGD variants, Adam-family methods, memory-efficient optimizers, learned optimizers, schedules, weight decay, gradient clipping, normalization effects, and training stability.

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Optimization for Deep Learning") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Optimization for Deep Learning")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Boundary With Mathematical Optimization

Use `Mathematics/Optimization` when the paper is primarily about mathematical optimization theory or numerical optimization independent of neural-network training.
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
