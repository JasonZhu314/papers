---
note_type: moc
title: MOC - Physics-Informed Learning
topics:
  - SciML
  - Physics-Informed Learning
publish: true
---

# MOC - Physics-Informed Learning

## Scope

Methods that use physics, PDE residuals, boundary conditions, conservation laws, or variational principles as training structure.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Physics-Informed Learning")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use tags to separate `pinn`, `deep-ritz`, `conservation-law`, `boundary-condition`, and `variational-method`.
