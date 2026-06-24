---
note_type: moc
title: MOC - Mathematics
topics:
  - Mathematics
publish: true
---

# MOC - Mathematics

## Scope

Mathematics papers and technical notes relevant to computational mathematics, scientific machine learning, AI foundations, and long-term research taste. The public folder tree is compact at the MOC level and more detailed at leaf placement level.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Mathematics")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use `Mathematics/Optimization` for optimization as a mathematical or numerical discipline.
- Use AI-facing folders for optimizer papers whose main contribution is neural-network training behavior.
- Cross-list with `topics` instead of duplicating files.
