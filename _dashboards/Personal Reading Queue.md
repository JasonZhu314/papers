---
note_type: dashboard
publish: true
---

# Personal Reading Queue

This queue tracks papers the user explicitly wants to handle next. It is separate from the foundational queue.

## Already Read, Notes Needed

| Order | Paper | Next Action | Target Depth |
| --- | --- | --- | --- |
| 1 | [[Generative AI/Diffusion and Score Models/DDPM|DDPM]] | Reconstruct the core diffusion formulation, training objective, sampling process, and relation to score models. | deep |
| 2 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/FNO|FNO]] | Turn prior reading into a durable note: operator-learning setup, Fourier layer, experiments, limitations. | deep |
| 3 | [[SciML/Operator Learning/Neural Operators/Graph Neural Operators/Point Cloud Neural Operator for Parametric PDEs on Complex and Variable Geometries|PCNO]] | Write the method/evaluation note and compare against FNO/GNO-style operator learning. | standard |

```dataview
TABLE WITHOUT ID file.link AS Paper, topics AS Topics, depth AS Depth, importance AS Importance, status AS Status, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(tags, "personal-reading-queue") AND contains(tags, "notes-needed")
SORT importance DESC, file.name ASC
```

## Planned Reading

| Order | Paper | Why It Is In This Queue | Target Depth |
| --- | --- | --- | --- |
| 1 | [[SciML/Inverse Problems and Data Assimilation/Latent Auto-Encoder EnKF|Latent Auto-Encoder EnKF]] | Connects latent representation learning with data assimilation. | standard |
| 2 | [[SciML/Physics-Informed Learning/PINNs/PiGGO|PiGGO]] | Relevant to physics-informed/scientific learning methods. | standard |
| 3 | [[SciML/Operator Learning/Neural Operators/Graph Neural Operators/A Structure-Preserving Graph Neural Solver for Parametric Hyperbolic Conservation Laws|A Structure-Preserving Graph Neural Solver for Parametric Hyperbolic Conservation Laws]] | Graph neural solver with conservation/structure-preserving concerns. | standard |
| 4 | [[SciML/Operator Learning/Neural Operators/Graph Neural Operators/M-PCNO|M-PCNO]] | Direct follow-up/variant for point-cloud neural operator reading. | standard |
| 5 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/GeoPT|GeoPT]] | Geometry-aware operator-learning direction. | standard |
| 6 | [[SciML/Inverse Problems and Data Assimilation/PAINT|PAINT]] | Neural twin / dynamical-system reconstruction from measurements. | standard |

```dataview
TABLE WITHOUT ID file.link AS Paper, topics AS Topics, depth AS Depth, importance AS Importance, status AS Status, date_added AS Added
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(tags, "personal-reading-queue") AND !contains(tags, "notes-needed")
SORT importance DESC, file.name ASC
```

## Completion Rule

- Already-read papers leave the `notes-needed` section only after the note is good enough for the target depth.
- Planned papers move from `queued` to `reading` when an active Codex reading session starts.
- Set `status: done` only after the note is complete enough to be useful later.