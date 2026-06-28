---
note_type: dashboard
publish: true
---

# First Reading Queue

This is the first constrained queue for building foundations without trying to process the full library at once.

Use this queue as a 4-6 week starting plan. Do not add more papers until at least half of this list is `done` or deliberately `archived`.

## Reading Strategy

- Start with operator learning because it is closest to the current research focus.
- Use numerical analysis papers to rebuild the computational-mathematics lens needed to judge SciML methods.
- Use optimization papers to understand training behavior, normalization, initialization, and optimizer claims.
- Most papers are `standard`; only field-defining papers are marked `deep`.

## Suggested Order

| Order | Paper | Why It Is In The First Queue | Target Depth |
| --- | --- | --- | --- |
| 1 | [[SciML/Operator Learning/DeepONet/DeepONet|DeepONet]] | Canonical operator-learning architecture and universal approximation framing. | deep |
| 2 | [[SciML/Operator Learning/Neural Operators/Neural Operator - Graph Kernel Network for PDE|Neural Operator - Graph Kernel Network for PDE]] | Early neural-operator formulation on graph/kernel structure. | deep |
| 3 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/FNO|FNO]] | Central baseline for Fourier neural operators and PDE solution operators. | deep |
| 4 | [[SciML/Operator Learning/Neural Operators/Neural Operator|Neural Operator]] | General neural-operator framing beyond one architecture. | deep |
| 5 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/Learning Parametric Solution Operators|Learning Parametric Solution Operators]] | Older/operator-learning perspective useful for historical grounding. | standard |
| 6 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/PINO|PINO]] | Connects neural operators with physics-informed constraints. | standard |
| 7 | [[SciML/Operator Learning/Neural Operators/Fourier Neural Operators/Kernel Methods are Competitive for Operator Learning|Kernel Methods are Competitive for Operator Learning]] | Forces comparison against non-deep-learning baselines. | standard |
| 8 | [[SciML/Operator Learning/Operator Learning|Operator Learning]] | Survey/overview pass after the core examples are in place. | standard |
| 9 | [[Mathematics/Numerical Analysis/Introduction to Numerical Analysis|Introduction to Numerical Analysis]] | Rebuilds the numerical-analysis baseline vocabulary. | standard |
| 10 | [[Mathematics/Numerical Analysis/Finite Difference Methods|Finite Difference Methods]] | Core discretization background for PDE-oriented SciML. | standard |
| 11 | [[Mathematics/Numerical Analysis/Weierstrass and Approximation Theory|Weierstrass and Approximation Theory]] | Approximation-theory background for neural approximation claims. | standard |
| 12 | [[Mathematics/Numerical Analysis/Barycentric Lagrange Interpolation|Barycentric Lagrange Interpolation]] | Practical interpolation and stability perspective. | standard |
| 13 | [[Mathematics/Numerical Analysis/Lebesgue Constants in Polynomial Interpolation|Lebesgue Constants in Polynomial Interpolation]] | Helps judge interpolation, approximation, and stability claims. | standard |
| 14 | [[Mathematics/Numerical Analysis/ODE Solvers/Integration of Stiff Equations|Integration of Stiff Equations]] | Stiffness is central for scientific simulation and learned solvers. | standard |
| 15 | [[Foundations/Optimization for Deep Learning/SGD|SGD]] | Baseline optimizer and implicit-bias foundation. | deep |
| 16 | [[Foundations/Optimization for Deep Learning/ADAM|ADAM]] | Default adaptive optimizer in deep learning. | deep |
| 17 | [[Foundations/Optimization for Deep Learning/Decoupled Weight Decay Regularization|Decoupled Weight Decay Regularization]] | Clarifies AdamW-style optimizer practice. | standard |
| 18 | [[Foundations/Optimization for Deep Learning/Batch Norm|Batch Norm]] | Foundational normalization/training-stability method. | deep |
| 19 | [[Foundations/Optimization for Deep Learning/Dropout|Dropout]] | Classic regularization method and generalization baseline. | standard |
| 20 | [[Foundations/Optimization for Deep Learning/Kaiming He Initialization|Kaiming He Initialization]] | Initialization lens for deep networks and residual-style architectures. | standard |

## Live Queue

```dataview
TABLE WITHOUT ID file.link AS Paper, topics AS Topics, depth AS Depth, importance AS Importance, status AS Status, date_read AS Read
FROM ""
WHERE note_type = "paper" AND publish != false AND contains(tags, "first-reading-queue")
SORT status ASC, importance DESC, file.name ASC
```

## Completion Rule

A paper leaves this queue when one of these is true:

- `status: done` and the note is good enough for its target depth;
- `status: archived` because it is not worth reading now;
- it is replaced by a better paper after explicit review.

## Next Review

After 10 papers are completed or archived, refresh this dashboard and decide whether the next queue should focus on Neural Operators, PINNs/Deep Ritz, numerical PDEs, or optimization theory.