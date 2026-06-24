# Catalog

This catalog is a starting map, not a permanent ontology. The folder tree should help place papers quickly. The MOCs should help synthesize topics that matter.

## Design Rules

- Folder = where you would look for the paper later.
- Topic metadata = where the paper should appear in MOCs.
- Tags = cross-cutting properties such as `fno`, `vit`, `rlhf`, `denoising`, `operator-learning`, or `pde`.
- MOCs live at high-level or synthesis-level folders.
- Leaf folders do not need MOCs until they have enough papers or a real synthesis question.

## Current Top-Level Areas

### Mathematics

Mathematics is a top-level area because computational mathematics is part of the research identity of this system, not merely background reading.

- `Analysis`: real analysis, functional analysis, harmonic analysis, and measure-theoretic background.
- `Differential Equations`: ODEs, PDEs, dynamical systems, control theory, Sobolev spaces, spectral theory, and calculus of variations.
- `Numerical Analysis`: approximation theory, numerical PDEs, error analysis, stability, discretization, and time-stepping.
- `Numerical Linear Algebra`: matrix computations, Krylov methods, eigensolvers, preconditioning, low-rank methods, randomized linear algebra, and iterative solvers.
- `Optimization`: optimization as a mathematical or numerical discipline.
- `Probability and Statistics`: stochastic processes, high-dimensional probability, and statistical inference.
- `Geometry`: differential geometry, Riemannian geometry, algebraic geometry, and geometric methods.
- `Algebra`: abstract algebra, number theory, representation theory, and algebraic structures.
- `TCS`: theoretical computer science as mathematics: algorithms, complexity, combinatorics, and graph theory.

Optimization boundary:

- Put optimization theory, convex/nonconvex analysis, variational methods, first-order/second-order methods, stochastic approximation, optimal transport, and convergence-rate papers under `Mathematics/Optimization`.
- Put optimizer papers for neural-network training under `Foundations/Optimization for Deep Learning`, `LLMs/Pretraining`, or another AI-facing folder when the main contribution is training behavior.
- Cross-list with `topics` rather than duplicating files.

Numerical analysis boundary:

- Put discretization, approximation, quadrature, numerical PDE, error analysis, and stability papers under `Mathematics/Numerical Analysis`.
- Put matrix computation, linear solvers, eigenvalue algorithms, preconditioning, low-rank methods, and randomized linear algebra under `Mathematics/Numerical Linear Algebra`.

### Computer Science

Use this top-level area for non-AI computer science papers: algorithms, complexity, programming languages, distributed systems, databases, security, cryptography, and software engineering.

### Physics

Use this top-level area for physics papers that are useful background for computational mathematics, scientific machine learning, scientific applications, or general scientific taste.

### AI for Science

AI for Science is for domain-facing work where AI accelerates scientific discovery or changes scientific practice. Put papers here when the scientific discovery, scientific workflow, or domain result is the main reason to remember the work.

- `AI for Mathematics`: theorem proving, autoformalization, conjecture generation, mathematical discovery, and AI-assisted mathematical research.
- `Biology and Medicine`: protein structure, genomics, drug discovery, medical science, and biomedical discovery systems.
- `Chemistry and Materials`: molecular generation, force fields, reactions, materials discovery, and lab automation for chemistry/materials.
- `Physics`: AI systems aimed at physical discovery, simulation campaigns, or physics-domain scientific insight.
- `Climate and Earth Systems`: weather, climate, geoscience, and Earth-system discovery.
- `Engineering Systems`: scientific and engineering design, control, and discovery systems.
- `Scientific Foundation Models`: broad pretrained models or foundation-model-style systems for scientific domains.
- `Scientific Agents and Labs`: AI scientists, autonomous laboratories, scientific agents, and discovery pipelines.

Boundary with SciML:

- Put a paper under `AI for Science` when the key contribution is scientific discovery, domain impact, or an AI-driven scientific workflow.
- Put a paper under `SciML` when the key contribution is a method for scientific computing, PDEs, inverse problems, operator learning, or numerical surrogates.
- Use `topics` to cross-list papers such as AlphaFold-style domain systems that also introduce reusable SciML methods.

### SciML

SciML is the primary research area and is intentionally the most detailed branch.

- `Operator Learning`: methods that learn mappings between function spaces or solution operators.
- `Physics-Informed Learning`: methods that solve or regularize models using physics constraints, PDE residuals, or variational principles.
- `Neural Differential Equations`: continuous-time and differential-equation-based neural models.
- `PDE Solvers and Surrogates`: learned solvers, surrogate models, mesh-aware methods, and time-stepping methods.
- `Inverse Problems and Data Assimilation`: recovering hidden states, parameters, or dynamics from observations.
- `Uncertainty Quantification and Reliability`: uncertainty, calibration, robustness, failure detection, and trustworthy scientific prediction.
- `Theory`: approximation, generalization, stability, and error analysis.

Placement corrections:

- DeepONet belongs under `Operator Learning`, because it learns operators between function spaces.
- Fourier Neural Operator, Graph Neural Operator, and transformer-style neural operators belong under `Operator Learning/Neural Operators`.
- PINNs belong under `Physics-Informed Learning`.
- Deep Ritz belongs under `Physics-Informed Learning/Variational and Energy Methods`.
- Neural ODEs belong under `Neural Differential Equations`, even though they also overlap with general deep learning.

### LLMs

LLMs are organized by research lifecycle:

- `Pretraining`: data, architecture, scaling, and training stability.
- `Post-training`: SFT, preference optimization, RLHF/RLAIF, reward models, and instruction-following behavior.
- `Inference`: decoding, serving, KV cache, quantization, and speculative decoding.
- `Capabilities`: reasoning, tool use, agents, long context, and multimodal LLMs.
- `Retrieval and Memory`: RAG, context engineering, retrieval, and memory systems.
- `Evaluation`: benchmarks, eval methodology, and failure analysis.

Mechanistic interpretation of LLM internals belongs under `Mechanistic Interpretability`; link or cross-list from LLM notes when the model family matters.

### Computer Vision

Computer vision mixes task folders and architecture folders because both are useful lookup modes.

- Task folders: classification, detection, segmentation, low-level vision, video, 3D vision, and vision-language models.
- Architecture folders: CNNs, vision transformers, and vision foundation models.

Use task folders when the problem is the main reason to remember the paper. Use architecture folders when the architecture itself is the main contribution.

### Generative AI

Generative AI is organized by model family and generation regime:

- diffusion and score models;
- GANs;
- VAEs and flow models;
- autoregressive generation;
- image and video generation;
- multimodal generation;
- evaluation and safety.

### Foundations

Foundational ML papers live here when they are not mainly tied to a specific application area:

- optimization;
- learning theory;
- probabilistic ML and Bayesian methods;
- information theory;
- causality;
- representation learning;
- data-centric ML;
- evaluation and benchmarks.

### Mechanistic Interpretability

Mechanistic Interpretability is a top-level area because understanding model internals is the organizing question. Alignment, safety, robustness, and monitoring live here when they are framed as applications of understanding or controlling model behavior.

- `Circuits and Features`: circuits, features, feature geometry, and localized computations.
- `Sparse Autoencoders`: SAE methods and feature dictionaries.
- `Activation Patching and Causal Tracing`: causal interventions, path patching, causal tracing, and localization.
- `Representation Geometry`: probes, linear representations, superposition, and geometry of internal states.
- `Model Internals and Probing`: interpretability methods that inspect learned internals without a narrower home.
- `Alignment and Safety`: safety, alignment, deception, oversight, jailbreaks, and capability-risk work.
- `Robustness and Monitoring`: robustness, anomaly detection, monitoring, and deployment-time failure detection.

### Other Top-Level Areas

- `Graph and Geometric Learning`
- `Reinforcement Learning and Control`
- `Robotics and Embodied AI`
- `ML Systems`

These areas start shallow. Add MOCs only when reading volume makes synthesis useful.

## When To Add A New Folder

Add a folder when at least one of these is true:

- you expect repeated reading in that area;
- the area is a stable research community or method family;
- the distinction changes where you would look for a paper later.

Do not add a folder just because a paper has a keyword. Use tags for that.

## When To Add A New MOC

Add a MOC when at least one of these is true:

- there are around 10 papers in the area;
- you need to compare methods or trace a field history;
- you are preparing a survey, proposal, related work section, or research direction;
- the topic is central to your current research.
