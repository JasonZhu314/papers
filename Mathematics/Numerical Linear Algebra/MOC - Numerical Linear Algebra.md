---
note_type: moc
title: MOC - Numerical Linear Algebra
topics:
  - Mathematics
  - Numerical Linear Algebra
publish: true
---

# MOC - Numerical Linear Algebra

## Scope

Matrix factorizations, eigenvalue problems, Krylov methods, randomized linear algebra, preconditioning, iterative solvers, low-rank methods, and linear algebra kernels for computational mathematics and AI.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Numerical Linear Algebra")
SORT status ASC, importance DESC, year DESC, file.name ASC
```
