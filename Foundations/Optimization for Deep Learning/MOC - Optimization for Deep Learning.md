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

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Optimization for Deep Learning")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Boundary With Mathematical Optimization

Use `Mathematics/Optimization` when the paper is primarily about mathematical optimization theory or numerical optimization independent of neural-network training.
