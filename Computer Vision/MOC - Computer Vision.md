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

## Active Papers

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, depth AS Depth, status AS Status, importance AS Importance, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Computer Vision") AND (status = "reading" OR status = "queued")
SORT choice(status = "reading", 0, 1) ASC, importance DESC, date_added DESC, file.name ASC
```

## Reading Map

```dataview
TABLE WITHOUT ID file.link AS Paper, year AS Year, venue AS Venue, topics AS Topics, depth AS Depth, status AS Status, importance AS Importance, citation_key AS Cite
FROM ""
WHERE note_type = "paper" AND publish != false AND !contains(file.path, "_templates/") AND contains(topics, "Computer Vision")
SORT choice(status = "reading", 0, choice(status = "queued", 1, choice(status = "inbox", 2, choice(status = "library", 3, choice(status = "done", 4, 5))))) ASC, importance DESC, year DESC, file.name ASC
```

## Synthesis

- Use task folders for detection, segmentation, restoration, 3D, video, and vision-language work.
- Use architecture folders for papers remembered mainly because of CNNs, vision transformers, or foundation-model architecture.

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
