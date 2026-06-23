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

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Neural Differential Equations")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use this area for papers where differential-equation structure is the main contribution, even if the model is also relevant to general deep learning.
