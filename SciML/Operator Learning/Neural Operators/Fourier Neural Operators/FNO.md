---
note_type: paper
title: "Fourier Neural Operator for Parametric Partial Differential Equations"
aliases:
  - "FNO"
  - "Fourier Neural Operator"
authors:
  - "Zongyi Li"
  - "Nikola Kovachki"
  - "Kamyar Azizzadenesheli"
  - "Burigede Liu"
  - "Kaushik Bhattacharya"
  - "Andrew Stuart"
  - "Anima Anandkumar"
year: 2021
venue: "ICLR 2021"
paper_type: research
status: done
depth: deep
importance: 5
topics:
  - "SciML"
  - "Operator Learning"
  - "Neural Operators"
  - "Fourier Neural Operators"
tags: []
citation_key: "li2021fourier"
zotero_key:
zotero_uri:
zotero_pdf_uri:
url: "https://arxiv.org/abs/2010.08895"
doi:
arxiv: "2010.08895v3"
pdf: "_attachments/PDFs/SciML/Operator Learning/Neural Operators/Fourier Neural Operators/FNO.pdf"
date_added: 2026-06-24
date_read: 2026-07-02
has_ideas: false
publish: true
---

# Fourier Neural Operator for Parametric Partial Differential Equations

PDF: [[_attachments/PDFs/SciML/Operator Learning/Neural Operators/Fourier Neural Operators/FNO.pdf|Open PDF]]

## One-Sentence Memory

[[FNO]] learns a PDE solution operator between function spaces by replacing expensive learned physical-space kernel integrals with truncated Fourier-domain channel mixing, giving a fast neural operator that can transfer across resolutions on uniform grids.

## Reading Intent

- Why this paper was worth deep reading: It is the foundational [[Neural Operators]] paper that made operator learning practical and widely used for parametric PDE surrogate modeling.
- What I wanted to be able to reconstruct: The operator-learning setup, the general neural-operator layer, the Fourier specialization, the discretization and FFT implementation, and what the numerical evidence actually supports.

## Context

- Problem setting: Many scientific and engineering workflows require solving a PDE repeatedly for different input functions, such as initial conditions, coefficients, forcings, or observed histories.
- Why this mattered at the time: Classical numerical solvers solve one instance at a time; finite-dimensional neural surrogates are fast but tied to a discretization; neural-FEM and [[PINNs]] are mesh-free but usually require a new optimization for each PDE instance.
- What prior work could not do: Earlier neural operators were conceptually appropriate but expensive because they evaluated learned integral kernels in physical space. CNN-style surrogates could run fast, but their learned maps were between fixed discretized arrays rather than function spaces.

## Core Contribution

- Main idea: Learn the PDE solution operator $G^\dagger : \mathcal{A} \to \mathcal{U}$ using layers that combine local channel mixing, nonlinear activations, and global spectral convolution.
- Technical novelty: Replace the general learned kernel integral operator with a convolutional operator parameterized directly in Fourier space:

$$
K v_t(x) = \mathcal{F}^{-1}(R \cdot \mathcal{F}(v_t))(x).
$$

- Research taste or insight: The paper keeps the operator-learning target but makes the nonlocal layer computationally viable by using FFTs and learning only a fixed number of low Fourier modes.

## Method Reconstruction

### Setup

- Inputs: A function $a \in \mathcal{A}$, such as an initial condition, a diffusion coefficient, or an observed vorticity history.
- Outputs: A solution function $u \in \mathcal{U}$, such as a final-time state, elliptic PDE solution, or future vorticity trajectory.
- Assumptions: Training data are pairs $(a_j,u_j)$ sampled from a distribution $\mu$, with $u_j = G^\dagger(a_j)$ possibly observed only through pointwise discretizations.
- Objective: Approximate the true operator $G^\dagger$ by a parametric operator $G_\theta$ using an empirical version of the risk

$$
\min_{\theta \in \Theta} \mathbb{E}_{a \sim \mu}
\left[C(G_\theta(a),G^\dagger(a))\right].
$$

This is a distributional operator-learning objective, not an operator-norm approximation over all possible inputs.

### Model Or Algorithm

The general neural operator first lifts the input function into a latent channel field:

$$
v_0(x)=P(a(x)).
$$

It then applies several update layers:

$$
v_{t+1}(x)=\sigma \left(Wv_t(x)+K(a;\phi)v_t(x)\right).
$$

Finally it projects the latent representation back to the output function:

$$
u(x)=Q(v_T(x)).
$$

In the general formulation, the nonlocal operator is a kernel integral:

$$
K(a;\phi)v_t(x)=\int_D \kappa(x,y,a(x),a(y);\phi)v_t(y)dy.
$$

[[FNO]] specializes this by removing the direct input-dependence of the kernel and using a translation-invariant convolution kernel $\kappa(x-y)$, which can be implemented as multiplication in Fourier space.

### Mathematical Structure

- Key definitions:
  - $D \subset \mathbb{R}^d$: PDE domain.
  - $\mathcal{A}$: input function space.
  - $\mathcal{U}$: output solution function space.
  - $G^\dagger : \mathcal{A} \to \mathcal{U}$: true PDE solution operator.
  - $G_\theta$: learned neural operator.
  - $D_j$: finite discretization used to observe a training pair.
  - $v_t(x) \in \mathbb{R}^{d_v}$: latent feature field.
  - $R(k) \in \mathbb{C}^{d_v \times d_v}$: learned Fourier-mode channel mixing matrix.
- Key equations:
  - General operator-learning objective:

$$
\min_{\theta \in \Theta} \mathbb{E}_{a \sim \mu}
\left[C(G_\theta(a),G^\dagger(a))\right].
$$

  - General kernel integral layer:

$$
K(a;\phi)v_t(x)=\int_D \kappa(x,y,a(x),a(y);\phi)v_t(y)dy.
$$

  - Fourier layer:

$$
v_{t+1}(x)=\sigma \left(Wv_t(x)+\mathcal{F}^{-1}(R \cdot \mathcal{F}(v_t))(x)\right).
$$

  - Per-mode channel mixing:

$$
(R \cdot \widehat{v})_{k,\ell}
=
\sum_{j=1}^{d_v} R_{k,\ell,j}\widehat{v}_{k,j}.
$$

- Important theorem or proposition: The main paper does not present a new approximation theorem as the core contribution. Its formal contribution is the operator-learning formulation and Fourier parameterization, supported primarily by empirical evidence.
- What the theory actually supports: The architecture has a discretization-consistent parameterization because the learned Fourier coefficients can be evaluated on different resolutions. This is not a proof of exact mesh-invariant accuracy or arbitrary-geometry generalization.

### Implementation Details

- Architecture: Four Fourier integral operator layers with local linear transforms, ReLU activations, and batch normalization, followed by projection to the output field.
- Training or optimization: Adam for 500 epochs, initial learning rate $0.001$, halved every 100 epochs.
- Data preprocessing: Lower-resolution datasets are downsampled from higher-resolution solver data.
- Important hyperparameters:
  - Usually $N=1000$ training instances and 200 test instances.
  - For 1D Burgers: $k_{\max}=16$, $d_v=64$.
  - For 2D problems: $k_{\max}=12$, $d_v=32$.
  - Experiments were run on a single Nvidia V100 GPU with 16GB memory.

The practical FFT implementation usually computes a full FFT, multiplies only retained low modes, zero-fills the rest, and applies an inverse FFT. Even though the learned spectral multiplication uses only $|Z_{k_{\max}}|$ modes, the activation memory and FFT buffers still scale roughly linearly with the number of grid points.

## Experiments And Evaluation

### Evaluation Questions

- Can [[FNO]] approximate PDE solution operators more accurately than finite-dimensional neural surrogates and earlier neural operators?
- Does the error remain stable as grid resolution changes?
- Can the same trained model be evaluated on a higher-resolution grid without retraining?
- Can a trained [[FNO]] serve as a fast surrogate inside a downstream Bayesian inverse problem?

### Datasets And Benchmarks

- [[Burgers' Equation]]: Learn $u_0 \mapsto u(\cdot,1)$ on a 1D periodic domain.
- [[Darcy Flow]]: Learn the coefficient-to-solution map $a(x) \mapsto u(x)$ for

$$
-\nabla \cdot (a(x)\nabla u(x)) = f(x), \quad u|_{\partial D}=0.
$$

- [[Navier-Stokes]]: Learn future vorticity from past vorticity in 2D incompressible flow:

$$
\partial_t w + u \cdot \nabla w = \nu \Delta w + f, \quad \nabla \cdot u=0.
$$

Here $u$ is velocity and $w=\nabla \times u$ is vorticity. Vorticity is the modeled state; velocity can be recovered from vorticity through a Poisson solve for the stream function.

### Baselines

- NN: Pointwise feedforward network.
- FCN: Fully convolutional network surrogate for grid-based field-to-field regression.
- GCN: Graph convolutional network baseline.
- PCANN: PCA compression of input and output fields plus neural network interpolation between latent spaces.
- RBM: Reduced basis method using a POD basis.
- GNO: Graph neural operator using physical-space kernel/Nystrom evaluation.
- LNO: Low-rank neural operator, similar in spirit to low-rank kernel decompositions and unstacked [[DeepONet]].
- MGNO: Multipole graph neural operator, an accelerated physical-space neural operator.
- U-Net: Encoder-decoder CNN with skip connections.
- TF-Net: Turbulent-flow network using spatial and temporal convolutions.
- ResNet: Residual CNN baseline for time-dependent Navier-Stokes.

### Metrics

- Main metric: Relative error on held-out test functions.
- Timing comparison in the inverse problem: Per-forward-evaluation runtime of [[FNO]] vs pseudo-spectral solver.

### Main Results

- Burgers: [[FNO]] obtains the lowest error across resolutions from $s=256$ to $s=8192$, with error around $0.014$ to $0.016$. FCN error grows substantially with resolution.
- Darcy: [[FNO]] obtains roughly $0.010$ relative error across resolutions, outperforming PCANN, RBM, GNO, LNO, and MGNO.
- Navier-Stokes: At fixed $64 \times 64$ resolution, FNO-3D is strongest when data are sufficient; FNO-2D can be better in lower-data or harder viscosity regimes.
- Zero-shot super-resolution: A model trained on $64 \times 64 \times 20$ Navier-Stokes data is evaluated on $256 \times 256 \times 80$ data, supporting spatial and temporal resolution transfer.
- Bayesian inverse problem: [[FNO]] is used as the forward surrogate inside function-space MCMC to infer initial vorticity from sparse noisy observations at $T=50$.

### Ablations And Diagnostics

- Spectral analysis: The Navier-Stokes spectrum follows a turbulence-like power-law decay, close to the Kolmogorov $k^{-5/3}$ behavior, indicating substantial multiscale content.
- Truncation diagnostic: Figure 5 shows that simply truncating to low Fourier modes loses information, so [[FNO]] should not be interpreted as merely low-pass filtering the solution.
- Explanation offered by the paper: Low-mode global spectral mixing is combined with local channel mixing, nonlinear activations, and multiple layers, allowing the full network to recover high-frequency structure better than a single Fourier truncation would.

### Evidence Quality

- What is convincing:
  - The Burgers and Darcy resolution sweeps clearly show stable [[FNO]] error across downsampled grids and degrading FCN behavior.
  - Comparisons against earlier operator baselines show a meaningful advantage for the Fourier parameterization.
  - The inverse-problem experiment demonstrates why fast amortized forward operators matter in practice.
- What is weak:
  - The super-resolution evidence is empirical and tied to uniform-grid FFT evaluation.
  - Figure 1 appears to have a caption/layout inconsistency: the visible figure is the Navier-Stokes super-resolution example, while the Fourier-layer architecture is shown in Figure 2.
  - The paper does not prove arbitrary mesh generalization or exact boundary-condition satisfaction.
  - The Bayesian inverse problem description omits some posterior and noise-model details in the main text.
  - The Darcy codomain $H_0^1$ describes the true PDE solution space, but the vanilla architecture does not hard-enforce $u|_{\partial D}=0$.

## Related Work And Field Position

- Direct predecessors: Earlier [[Neural Operators]], especially graph neural operator and multipole graph neural operator work by the same group; operator-learning methods such as [[DeepONet]]; reduced-order surrogate models such as PCANN and RBM.
- Competing lines:
  - Finite-dimensional CNN surrogates, including FCN, U-Net, ResNet, and TF-Net.
  - Neural-FEM and [[PINNs]], which parameterize individual solution functions rather than a reusable solution operator.
  - Classical numerical solvers such as FEM, FDM, and pseudo-spectral methods.
- Follow-up papers: Later work built many variants around spectral neural operators, geometry-aware neural operators, physics-informed neural operators, and improved operator-learning architectures.
- What changed after this paper: [[FNO]] became a default baseline and conceptual template for neural operator research: lift a function, apply global operator layers, use nonlinear local transformations, and evaluate across discretizations when possible.

## Field Map And Reading Landmarks

Read the field as several overlapping lines: operator-learning theory, neural-operator architectures, geometry and mesh handling, physics-informed training, benchmarks, and large-scale scientific applications.

### Suggested Reading Order

1. [[DeepONet]] - read first as the parallel operator-learning paradigm based on branch/trunk networks and the universal approximation theorem for operators.
2. [[Neural Operator - Graph Kernel Network for Partial Differential Equations]] - read as the direct predecessor to [[FNO]] and the clearest path from learned kernel integrals to graph neural operators.
3. [[Multipole Graph Neural Operator for Parametric Partial Differential Equations]] - read to understand why physical-space kernel evaluation needed acceleration before [[FNO]].
4. [[Neural Operator - Learning Maps Between Function Spaces]] - read as the general framework paper that organizes GNO, MGNO, low-rank neural operators, and [[FNO]] under one theory.
5. [[Physics-Informed Neural Operator for Learning Partial Differential Equations]] - read after [[FNO]] to see how PDE residuals and data losses are combined at different resolutions.
6. [[Fourier Neural Operator with Learned Deformations for PDEs on General Geometries]] or [[Geometry-Informed Neural Operator for Large-Scale 3D PDEs]] - read to study the main weakness of vanilla [[FNO]]: geometry and nonuniform discretization.
7. [[PDEBench]] - read before trusting benchmark claims across papers.
8. [[Neural Operators for Accelerating Scientific Simulations and Design]] - read as a modern survey and field-positioning article.

### Core Operator-Learning Foundations

| Paper | Why It Matters | Read For |
| --- | --- | --- |
| [[DeepONet]] / "Learning nonlinear operators via DeepONet based on the universal approximation theorem of operators" (Lu et al., 2019/2021) | The other major foundational operator-learning architecture. | Branch/trunk decomposition; sensor-to-query formulation; contrast with [[FNO]]. |
| [[Neural Operator - Graph Kernel Network for Partial Differential Equations]] (Li et al., 2020) | Direct predecessor to [[FNO]]. | Learned kernel integrals, graph/Nystrom discretization, discretization-invariance motivation. |
| [[Multipole Graph Neural Operator for Parametric Partial Differential Equations]] (Li et al., 2020) | Attempts to fix GNO scaling with multipole-style multiresolution structure. | Why global physical-space interactions are expensive. |
| [[FNO]] (Li et al., 2020/2021) | Makes neural operators practical and widely reusable by moving kernel integration into Fourier space. | Spectral parameterization, zero-shot super-resolution, operator-learning benchmark template. |
| [[Neural Operator - Learning Maps Between Function Spaces]] (Kovachki et al., 2021) | General theory/framework paper for neural operators. | Universality, discretization invariance, relation among GNO, MGNO, LNO, and [[FNO]]. |

### Architecture Families After FNO

| Line | Landmark | Why Read |
| --- | --- | --- |
| Spectral operators | [[FNO]] | Canonical fast uniform-grid neural operator. |
| Branch/trunk operators | [[DeepONet]] | Different inductive bias: encode input sensors and query output coordinates. |
| Graph operators | [[Neural Operator - Graph Kernel Network for Partial Differential Equations]], [[Multipole Graph Neural Operator for Parametric Partial Differential Equations]] | Natural route for irregular samples and physical-space kernels, but scaling is hard. |
| Low-rank / separable operators | Low-rank neural operator and related [[DeepONet]] variants | Useful for seeing when operator kernels have exploitable low-dimensional structure. |
| U-shaped operators | [[U-NO - U-shaped Neural Operators]] | Adds multiscale encoder-decoder structure to neural operators for deeper models and memory efficiency. |
| Wavelet / localized spectral operators | [[Wavelet Neural Operator]] | Replaces pure Fourier modes with localized time-frequency structure; relevant when locality and multiscale features matter. |
| Laplace / dynamics-aware operators | [[Laplace Neural Operator]] | Uses Laplace-domain pole/residue structure; relevant for transient responses and non-periodic dynamics. |
| Convolutional neural operators | [[Convolutional Neural Operators for robust and accurate learning of PDEs]] | Revisits CNNs from a function-space consistency perspective. |
| Transformer operators | [[OFormer]], [[GNOT]] | Uses attention for irregular meshes, multiple input functions, and flexible query locations. |

### Geometry, Meshes, And Domains

| Paper | Bottleneck It Addresses | Why It Matters |
| --- | --- | --- |
| [[Fourier Neural Operator with Learned Deformations for PDEs on General Geometries]] / Geo-FNO | Vanilla [[FNO]] assumes rectangular domains and uniform grids for FFT. | Learns a deformation from irregular physical domains to a latent uniform grid. |
| [[Geometry-Informed Neural Operator for Large-Scale 3D PDEs]] / GINO | Large-scale 3D PDEs with varying geometry. | Combines graph operators and Fourier operators; important for industrial CFD-style settings. |
| [[Learning Neural Operators on Riemannian Manifolds]] / NORM | Functions defined on non-Euclidean domains. | Moves operator learning toward manifolds and Laplacian eigenfunction bases. |
| [[Learning Mesh-Based Simulation with Graph Networks]] / MeshGraphNets | Learned simulation on adaptive meshes. | Not a neural-operator paper in the strict [[FNO]] sense, but essential adjacent reading for mesh-based learned simulators. |

### Physics-Informed And Hybrid Training

| Paper | Why It Matters | Read For |
| --- | --- | --- |
| [[PINNs]] / "Physics-informed neural networks" (Raissi et al., 2019) | Important predecessor and contrast class. | Solving individual PDE instances with residual losses rather than amortized operator learning. |
| [[Physics-Informed Neural Operator for Learning Partial Differential Equations]] / PINO | Adds PDE residuals to operator learning. | Data plus physics losses, supervision at one resolution and residuals at another. |
| Physics-informed variants of LNO, FNO, and DeepONet | Broad follow-up family. | Data efficiency, small-data regimes, and residual-based regularization. |

### Benchmarks, Surveys, And Field Overviews

| Paper | Why It Matters | Use |
| --- | --- | --- |
| [[A comprehensive and fair comparison of two neural operators]] | Compares [[DeepONet]] and [[FNO]] with practical extensions and points out robustness/geometry issues. | Useful corrective to reading [[FNO]] as universally dominant. |
| [[PDEBench]] | Standardized benchmark suite for SciML and PDE surrogate models. | Read before comparing new methods on scattered PDE tasks. |
| [[Operator Learning - Algorithms and Analysis]] | Theory-oriented review. | Approximation, statistical, and numerical-analysis view of operator learning. |
| [[Neural Operators for Accelerating Scientific Simulations and Design]] | Broad modern overview. | Field map, applications, and current positioning of neural operators in simulation/design. |
| [[A Library for Learning Neural Operators]] | Introduces the `neuraloperator` library. | Practical implementation ecosystem and standardized model tooling. |

### Large-Scale SciML Applications To Know

| Paper/System | Relation To FNO | Why It Matters |
| --- | --- | --- |
| [[FourCastNet]] | Uses adaptive Fourier neural operators for global weather forecasting. | Shows Fourier/operator-style ideas scaling to high-resolution weather emulation. |
| [[GraphCast]] | Graph neural network weather model, not an FNO-style neural operator. | Landmark in data-driven scientific forecasting and graph-based learned dynamics. |
| [[Pangu-Weather]] | Transformer-based weather model, not operator learning in the narrow sense. | Important evidence that large-scale data-driven SciML can rival numerical weather prediction. |
| [[ClimaX]] | Foundation-model direction for weather and climate. | Useful for understanding the move from PDE-specific operators to general pretrained scientific models. |

### Reading Priorities

- Must-read next for operator learning: [[DeepONet]], [[Neural Operator - Graph Kernel Network for Partial Differential Equations]], [[Neural Operator - Learning Maps Between Function Spaces]], [[Physics-Informed Neural Operator for Learning Partial Differential Equations]].
- Must-read for geometry and practical PDE use: Geo-FNO, GINO, MeshGraphNets.
- Must-read for evaluation discipline: [[PDEBench]] and [[A comprehensive and fair comparison of two neural operators]].
- Must-read for SciML taste beyond operators: [[PINNs]], [[FourCastNet]], [[GraphCast]], [[Pangu-Weather]].

## Limitations And Failure Modes

- The standard Fourier layer assumes uniform grids for efficient FFT use.
- The convolutional Fourier kernel is a simplification of the general input-dependent kernel integral; the main implementation does not fully recover the general form $\kappa(x,y,a(x),a(y))$.
- Learned parameters are resolution-independent, but memory and runtime still scale with the number of grid points.
- Boundary conditions are mostly learned from data rather than exactly enforced.
- The method still requires expensive offline data generation from numerical solvers.
- For harder Navier-Stokes regimes with limited data, errors remain large.
- The empirical claims should not be read as proof of universal mesh invariance or guaranteed super-resolution accuracy.

## What To Remember

- Core problem: Learn a reusable PDE solution operator $G^\dagger : \mathcal{A} \to \mathcal{U}$ rather than solving one PDE instance at a time.
- Core method: Replace physical-space learned kernel integration with truncated Fourier-domain channel mixing, plus local linear maps and nonlinear activations.
- Core evidence: Strong performance on Burgers, Darcy, and Navier-Stokes; stable error across downsampled resolutions; zero-shot super-resolution demonstration; fast surrogate use in a Bayesian inverse problem.
- Core limitation: The standard method is most natural on uniform grids and does not hard-enforce PDE constraints or boundary conditions.
- Reusable pattern: Separate the continuum operator-learning target from the finite grid used for training, then design layers whose parameters have a resolution-consistent interpretation.
