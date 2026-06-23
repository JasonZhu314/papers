---
note_type: moc
title: MOC - Computer Vision
topics:
  - Computer Vision
publish: true
---

# MOC - Computer Vision

## Scope

Computer vision papers, organized by task when the problem is central and by architecture when the architecture is central.

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(topics, "Computer Vision")
SORT status ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use task folders for detection, segmentation, restoration, 3D, video, and vision-language work.
- Use architecture folders for papers remembered mainly because of CNNs, vision transformers, or foundation-model architecture.
