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

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Mathematical Optimization")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Boundary With AI Optimizers

Put Adam, AdamW, Lion, Muon, Shampoo, Sophia, learned optimizers, optimizer scaling studies, and neural-network training-stability papers under AI-facing folders unless the mathematical analysis is the main reason to remember the paper.
