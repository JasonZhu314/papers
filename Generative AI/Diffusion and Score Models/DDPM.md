---
note_type: paper
title: "Denoising Diffusion Probabilistic Models"
aliases:
  - "DDPM"
authors:
  - "Jonathan Ho"
  - "Ajay Jain"
  - "Pieter Abbeel"
year: 2020
venue: "NeurIPS 2020"
paper_type: research
status: done
depth: deep
importance: 5
topics:
  - "Generative AI"
  - "Diffusion and Score Models"
tags: []
citation_key: "ho2020denoising"
zotero_key:
zotero_uri:
zotero_pdf_uri:
url: "https://arxiv.org/abs/2006.11239"
doi:
arxiv: "2006.11239v2"
pdf: "_attachments/PDFs/Generative AI/Diffusion and Score Models/DDPM.pdf"
date_added: 2026-06-24
date_read: 2026-07-02
has_ideas: false
publish: true
---

# Denoising Diffusion Probabilistic Models

PDF: [[_attachments/PDFs/Generative AI/Diffusion and Score Models/DDPM.pdf|Open PDF]]

## One-Sentence Memory

[[DDPM]] made diffusion models into practical high-quality image generators by training a Markovian Gaussian reverse process with an $\epsilon$-prediction objective that connects variational inference, denoising score matching, and annealed Langevin dynamics.

## Reading Intent

- Why this paper was worth deep reading: It is the paper that turned earlier diffusion probabilistic models into a competitive deep generative modeling framework and established the training parameterization that later image diffusion models built on.
- What I wanted to be able to reconstruct: The forward noising process, the learned reverse chain, the variational bound decomposition, the $\epsilon$-prediction simplification, why this resembles denoising score matching, and what the experiments actually prove.

## Context

- Problem setting: Learn a generative model for images by gradually corrupting data into nearly standard Gaussian noise, then learning a reverse stochastic process that maps noise back to data.
- Why this mattered at the time: GANs, autoregressive models, flows, VAEs, and energy-based or score-matching models dominated high-quality image generation. Diffusion models were conceptually clean and likelihood-based, but had not yet been shown to produce competitive samples.
- What prior work could not do: [[Deep Unsupervised Learning using Nonequilibrium Thermodynamics]] introduced the diffusion-probabilistic modeling framework, but sample quality was not yet compelling. Score-based models such as NCSN had strong samples, but their Langevin sampler was added after score training rather than trained directly as a finite-time latent-variable sampler.

## Crash Course: Generative Modeling Prerequisites

This is the minimum theory needed to reconstruct Sections 2 and 3 of [[DDPM]] without treating the equations as magic. The paper is a useful first encounter with variational inference because almost every abstraction becomes concrete: the latent variables are the noisy images $x_1,\ldots,x_T$, the variational posterior is the known forward noising process, and the KL terms reduce to Gaussian mean-matching losses.

### The Generative Modeling Problem

The goal is to learn a distribution $p_\theta(x)$ that assigns high probability to samples from the unknown data distribution $q_{\mathrm{data}}(x)$. Maximum likelihood trains the model by maximizing:

$$
\mathbb{E}_{x \sim q_{\mathrm{data}}}[\log p_\theta(x)].
$$

Equivalently, maximum likelihood minimizes:

$$
D_{\mathrm{KL}}(q_{\mathrm{data}}(x)\|p_\theta(x))
=
\mathbb{E}_{q_{\mathrm{data}}}
[\log q_{\mathrm{data}}(x)-\log p_\theta(x)].
$$

The first term does not depend on $\theta$, so maximizing $\log p_\theta(x)$ is enough. Different generative model families mainly differ in how they make $p_\theta(x)$ tractable or sampleable:

- Autoregressive models factorize $p_\theta(x)$ into sequential conditionals, so likelihood is exact but sampling is sequential.
- Normalizing flows use an invertible map from a simple base density, so likelihood is exact but the architecture is constrained by invertibility.
- [[Auto-Encoding Variational Bayes|VAEs]] introduce latent variables and optimize a lower bound when exact marginal likelihood is intractable.
- [[GAN]]-style models learn to sample without explicit likelihood.
- Diffusion models introduce many latent variables $x_1,\ldots,x_T$ and train a reverse denoising chain with a variational bound.

### KL Divergence

KL divergence measures how costly it is to use one distribution $p$ when the data actually follow another distribution $q$:

$$
D_{\mathrm{KL}}(q\|p)
=
\mathbb{E}_{x \sim q}
\left[
\log \frac{q(x)}{p(x)}
\right].
$$

Important facts:

- $D_{\mathrm{KL}}(q\|p)\geq 0$.
- It is asymmetric: $D_{\mathrm{KL}}(q\|p) \neq D_{\mathrm{KL}}(p\|q)$ in general.
- In maximum likelihood, the direction is usually $D_{\mathrm{KL}}(q_{\mathrm{data}}\|p_\theta)$.
- In variational inference, the direction often becomes $D_{\mathrm{KL}}(q_{\phi}(z\mid x)\|p_\theta(z\mid x))$ because we choose an approximate posterior $q_\phi$ and compare it to the true posterior.

For two $d$-dimensional Gaussians, the KL has a closed form:

$$
D_{\mathrm{KL}}
(
\mathcal{N}(\mu_q,\Sigma_q)
\|
\mathcal{N}(\mu_p,\Sigma_p)
)
=
\frac{1}{2}
\left[
\log \frac{|\Sigma_p|}{|\Sigma_q|}
-d
+\mathrm{tr}(\Sigma_p^{-1}\Sigma_q)
+(\mu_p-\mu_q)^\top\Sigma_p^{-1}(\mu_p-\mu_q)
\right].
$$

This formula is the reason [[DDPM]] can turn variational inference into a denoising loss. Each reverse-transition KL compares two Gaussians. If the covariance of $p_\theta(x_{t-1}\mid x_t)$ is fixed, the only trainable part is the mean, and the KL becomes a weighted squared error between the true posterior mean and the model mean.

### Variational Inference And The ELBO

Latent-variable models define a joint distribution:

$$
p_\theta(x,z)=p(z)p_\theta(x\mid z).
$$

The likelihood is the marginal:

$$
p_\theta(x)=\int p_\theta(x,z)dz.
$$

This integral is often intractable. Variational inference introduces an easier distribution $q_\phi(z\mid x)$ and uses Jensen's inequality:

$$
\log p_\theta(x)
=
\log \int q_\phi(z\mid x)
\frac{p_\theta(x,z)}{q_\phi(z\mid x)}dz
\geq
\mathbb{E}_{q_\phi(z\mid x)}
\left[
\log p_\theta(x,z)-\log q_\phi(z\mid x)
\right].
$$

The right-hand side is the evidence lower bound:

$$
\mathrm{ELBO}(x)
=
\mathbb{E}_{q_\phi(z\mid x)}
[\log p_\theta(x\mid z)]
-
D_{\mathrm{KL}}(q_\phi(z\mid x)\|p(z)).
$$

The equivalent identity is:

$$
\log p_\theta(x)
=
\mathrm{ELBO}(x)
+
D_{\mathrm{KL}}(q_\phi(z\mid x)\|p_\theta(z\mid x)).
$$

So maximizing the ELBO does two things:

- It increases the model evidence $\log p_\theta(x)$.
- It makes the approximate posterior $q_\phi(z\mid x)$ closer to the true posterior $p_\theta(z\mid x)$.

The sign convention in [[DDPM]] is easy to miss. The paper writes a variational bound $L$ that is minimized:

$$
L
=
\mathbb{E}_{q}
\left[
-\log \frac{p_\theta(x_{0:T})}{q(x_{1:T}\mid x_0)}
\right].
$$

This is an upper bound on negative log likelihood:

$$
-\log p_\theta(x_0) \leq L.
$$

So $-L$ is the ELBO. When reading the paper, remember: the paper minimizes the negative-ELBO form.

### How DDPM Specializes Variational Inference

In a standard [[Auto-Encoding Variational Bayes|VAE]], the approximate posterior $q_\phi(z\mid x)$ is learned. In [[DDPM]], the "encoder" or inference distribution is fixed:

$$
q(x_{1:T}\mid x_0)
=
\prod_{t=1}^{T}q(x_t\mid x_{t-1}).
$$

It gradually corrupts $x_0$ into noise. The learned model runs in the opposite direction:

$$
p_\theta(x_{0:T})
=
p(x_T)\prod_{t=1}^{T}p_\theta(x_{t-1}\mid x_t).
$$

The latent variables are not semantic latents like in a VAE. They are noisy versions of the image at different noise levels. This makes the posterior structure unusually tractable because the forward process is linear Gaussian.

Expanding the negative ELBO gives:

$$
L
=
\mathbb{E}_{q}
\left[
-\log p(x_T)
-\sum_{t=1}^{T}\log p_\theta(x_{t-1}\mid x_t)
+\sum_{t=1}^{T}\log q(x_t\mid x_{t-1})
\right].
$$

After rearranging with Bayes' rule, the bound becomes a sum of interpretable terms:

$$
L
=
\mathbb{E}_{q}
\left[
D_{\mathrm{KL}}(q(x_T\mid x_0)\|p(x_T))
+\sum_{t>1}D_{\mathrm{KL}}(q(x_{t-1}\mid x_t,x_0)\|p_\theta(x_{t-1}\mid x_t))
-\log p_\theta(x_0\mid x_1)
\right].
$$

Interpretation:

- The first term says the final noisy image $x_T$ should look like the prior $\mathcal{N}(0,I)$. The schedule is chosen so this is nearly true and independent of $\theta$.
- The middle terms train each learned reverse transition to match the true reverse posterior of the fixed noising process.
- The final term is the reconstruction or decoder term for predicting data from the last slightly noisy state.

The key trick is that $q(x_{t-1}\mid x_t)$ is not directly tractable, but $q(x_{t-1}\mid x_t,x_0)$ is tractable during training because we know the original clean training image $x_0$.

### The Forward Diffusion Process

The forward process is:

$$
q(x_t\mid x_{t-1})
=
\mathcal{N}(x_t;\sqrt{1-\beta_t}x_{t-1},\beta_t I).
$$

Define:

$$
\alpha_t=1-\beta_t,
\quad
\bar{\alpha}_t=\prod_{s=1}^{t}\alpha_s.
$$

Repeatedly applying the Gaussian transition gives the closed form:

$$
q(x_t\mid x_0)
=
\mathcal{N}(x_t;\sqrt{\bar{\alpha}_t}x_0,(1-\bar{\alpha}_t)I).
$$

Equivalently:

$$
x_t
=
\sqrt{\bar{\alpha}_t}x_0
+
\sqrt{1-\bar{\alpha}_t}\epsilon,
\quad
\epsilon \sim \mathcal{N}(0,I).
$$

This closed form is what makes training efficient. To train at timestep $t$, we do not need to simulate $1,\ldots,t$. We sample a clean image, sample a noise vector, and construct $x_t$ directly.

### The Gaussian Posterior Used In Training

Because the forward process is linear Gaussian, the posterior needed for training is also Gaussian:

$$
q(x_{t-1}\mid x_t,x_0)
=
\mathcal{N}(x_{t-1};\tilde{\mu}_t(x_t,x_0),\tilde{\beta}_t I).
$$

The posterior variance is:

$$
\tilde{\beta}_t
=
\frac{1-\bar{\alpha}_{t-1}}{1-\bar{\alpha}_t}\beta_t.
$$

The posterior mean is:

$$
\tilde{\mu}_t(x_t,x_0)
=
\frac{\sqrt{\bar{\alpha}_{t-1}}\beta_t}{1-\bar{\alpha}_t}x_0
+
\frac{\sqrt{\alpha_t}(1-\bar{\alpha}_{t-1})}{1-\bar{\alpha}_t}x_t.
$$

This formula is just Gaussian conditioning. Conceptually, it combines two pieces of evidence:

- $x_t$ tells us where the noisy chain currently is.
- $x_0$ tells us which clean image generated the chain.

Since both the true posterior and learned reverse transition are Gaussian, the KL term is computable. If the learned covariance is fixed, minimizing:

$$
D_{\mathrm{KL}}
(q(x_{t-1}\mid x_t,x_0)\|p_\theta(x_{t-1}\mid x_t))
$$

is equivalent, up to constants and weights, to matching $\mu_\theta(x_t,t)$ to $\tilde{\mu}_t(x_t,x_0)$.

### From Mean Prediction To Noise Prediction

The posterior mean $\tilde{\mu}_t(x_t,x_0)$ depends on the clean image $x_0$. But from the closed-form noising equation, $x_0$ can be written in terms of $x_t$ and the sampled noise $\epsilon$:

$$
x_0
=
\frac{x_t-\sqrt{1-\bar{\alpha}_t}\epsilon}{\sqrt{\bar{\alpha}_t}}.
$$

So instead of training a network to predict $\tilde{\mu}_t$, [[DDPM]] parameterizes the mean through a network $\epsilon_\theta(x_t,t)$ that predicts the noise:

$$
\mu_\theta(x_t,t)
=
\frac{1}{\sqrt{\alpha_t}}
\left(
x_t
-
\frac{\beta_t}{\sqrt{1-\bar{\alpha}_t}}
\epsilon_\theta(x_t,t)
\right).
$$

Plugging this parameterization into the Gaussian KL gives a weighted noise-prediction objective:

$$
\mathbb{E}_{x_0,\epsilon}
\left[
\frac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar{\alpha}_t)}
\|\epsilon-\epsilon_\theta(x_t,t)\|^2
\right].
$$

Here $\sigma_t^2$ is the variance chosen for the learned reverse transition $p_\theta(x_{t-1}\mid x_t)$.

The simplified training objective drops the timestep-dependent weight:

$$
L_{\mathrm{simple}}(\theta)
=
\mathbb{E}_{t,x_0,\epsilon}
\left[
\|\epsilon-\epsilon_\theta(\sqrt{\bar{\alpha}_t}x_0+\sqrt{1-\bar{\alpha}_t}\epsilon,t)\|^2
\right].
$$

This is the practical objective that made the paper work well. It is still rooted in the ELBO derivation, but it is not the exact unweighted maximum-likelihood objective. It changes the relative importance of different timesteps and improves perceptual sample quality in the paper's experiments.

### Denoising Autoencoders And Score Matching

[[Denoising Autoencoders]] train a model to reconstruct clean data from corrupted data:

$$
\tilde{x}=x+\sigma\epsilon,
\quad
r_\theta(\tilde{x}) \approx x.
$$

For Gaussian corruption, the optimal denoiser is connected to the score of the noisy data distribution:

$$
\nabla_{\tilde{x}}\log q_\sigma(\tilde{x})
\approx
\frac{r^*(\tilde{x})-\tilde{x}}{\sigma^2}.
$$

The score is the gradient of log density. It points toward directions where the data density increases. [[A Connection Between Score Matching and Denoising Autoencoders]] is the classic result behind this intuition.

[[DDPM]] has the same structure at many noise levels. The corruption is:

$$
x_t
=
\sqrt{\bar{\alpha}_t}x_0
+
\sqrt{1-\bar{\alpha}_t}\epsilon.
$$

The conditional score of this Gaussian corruption is:

$$
\nabla_{x_t}\log q(x_t\mid x_0)
=
-
\frac{\epsilon}{\sqrt{1-\bar{\alpha}_t}}.
$$

After averaging over possible $x_0$ values that could have produced a given $x_t$, the optimal $\epsilon$ predictor corresponds to the score of the noisy marginal distribution $q_t(x_t)$. So the network's noise prediction can be interpreted as a score estimate:

$$
s_\theta(x_t,t)
\approx
-
\frac{\epsilon_\theta(x_t,t)}{\sqrt{1-\bar{\alpha}_t}}.
$$

This is why Section 3 says the objective resembles denoising score matching over multiple noise levels. The diffusion model is not merely training an autoencoder; it is training a family of denoisers whose outputs define the reverse generative dynamics.

### Langevin Dynamics Connection

Langevin dynamics uses a score function to sample from a distribution:

$$
x_{k+1}
=
x_k
+
\eta \nabla_x \log p(x_k)
+
\sqrt{2\eta}z_k,
\quad
z_k \sim \mathcal{N}(0,I).
$$

The update has two parts:

- Move toward higher-density regions using the score.
- Add noise so the sampler explores rather than collapses to a mode.

Score-based models estimate scores at several noise levels and use annealed Langevin dynamics to move from high noise to low noise. [[DDPM]] arrives at a similar sampler from variational inference: the reverse update moves in a denoising direction determined by $\epsilon_\theta(x_t,t)$ and adds Gaussian noise with coefficients derived from the forward schedule. This is why the paper can connect variational inference, denoising score matching, and Langevin dynamics in one framework.

### How To Reconstruct Sections 2 And 3

To reconstruct Section 2:

1. Start from the fixed forward Markov chain $q(x_{1:T}\mid x_0)$.
2. Write the learned reverse Markov chain $p_\theta(x_{0:T})$.
3. Write the negative ELBO:

$$
L
=
\mathbb{E}_{q}
\left[
-\log \frac{p_\theta(x_{0:T})}{q(x_{1:T}\mid x_0)}
\right].
$$

4. Rearrange it into the prior-matching term, reverse-transition KL terms, and reconstruction term.
5. Notice that only the reverse-transition and reconstruction terms train the neural network.

To reconstruct Section 3:

1. Use the closed form $q(x_t\mid x_0)$ to sample noisy inputs directly.
2. Use Gaussian conditioning to compute $q(x_{t-1}\mid x_t,x_0)$.
3. Use the Gaussian KL formula to turn each reverse-transition KL into a weighted mean-matching problem.
4. Substitute the $\epsilon$ parameterization of $\mu_\theta$.
5. Observe that the KL becomes weighted MSE on $\epsilon-\epsilon_\theta(x_t,t)$.
6. Drop the weights to obtain $L_{\mathrm{simple}}$.
7. Interpret $\epsilon_\theta$ as a score estimator up to the factor $-\frac{1}{\sqrt{1-\bar{\alpha}_t}}$.

The conceptual punchline is:

$$
\text{ELBO}
\rightarrow
\text{Gaussian KL terms}
\rightarrow
\text{mean matching}
\rightarrow
\text{noise prediction}
\rightarrow
\text{score-based denoising sampler}.
$$

## Core Contribution

- Main idea: Define a fixed Gaussian forward diffusion process $q(x_{1:T}\mid x_0)$ that destroys signal, and learn a Gaussian reverse process $p_\theta(x_{t-1}\mid x_t)$ that denoises one step at a time from $x_T \sim \mathcal{N}(0,I)$ to $x_0$.
- Technical novelty: Reparameterize the reverse-process mean so the neural network predicts the injected noise $\epsilon$ rather than directly predicting the posterior mean $\tilde{\mu}_t$ or the clean image $x_0$. This makes the training loss an MSE denoising objective over noise levels.
- Research taste or insight: The paper does not win by adding an exotic model architecture. Its central move is choosing the right supervised target for a latent-variable objective: predict the noise that made $x_t$, which turns a difficult reverse-transition learning problem into a stable denoising problem while preserving the variational-inference interpretation.

## Method Reconstruction

### Setup

- Inputs: Training images $x_0 \sim q(x_0)$, scaled to a continuous range for modeling and handled with a discrete decoder term at the final step.
- Outputs: Generated images sampled by first drawing $x_T \sim \mathcal{N}(0,I)$, then iteratively sampling $x_{T-1},\ldots,x_0$ from the learned reverse chain.
- Assumptions: The forward process is fixed, Markovian, Gaussian, and uses sufficiently small noise increments $\beta_t$ so that the reverse process can be modeled with Gaussian transitions.
- Objective: Maximize likelihood through a variational bound, then use a simplified weighted version of that bound that empirically improves sample quality.

### Model Or Algorithm

The forward process gradually adds Gaussian noise:

$$
q(x_t \mid x_{t-1}) = \mathcal{N}(x_t;\sqrt{1-\beta_t}x_{t-1},\beta_t I).
$$

With $\alpha_t=1-\beta_t$ and $\bar{\alpha}_t=\prod_{s=1}^t \alpha_s$, the useful closed form is:

$$
q(x_t\mid x_0)=
\mathcal{N}(x_t;\sqrt{\bar{\alpha}_t}x_0,(1-\bar{\alpha}_t)I).
$$

Equivalently, training can sample any timestep directly as:

$$
x_t = \sqrt{\bar{\alpha}_t}x_0+\sqrt{1-\bar{\alpha}_t}\epsilon,
\quad
\epsilon \sim \mathcal{N}(0,I).
$$

The learned reverse chain is:

$$
p_\theta(x_{0:T}) = p(x_T)\prod_{t=1}^T p_\theta(x_{t-1}\mid x_t),
\quad
p(x_T)=\mathcal{N}(0,I),
$$

$$
p_\theta(x_{t-1}\mid x_t)=
\mathcal{N}(x_{t-1};\mu_\theta(x_t,t),\Sigma_\theta(x_t,t)).
$$

The practical training algorithm:

1. Sample $x_0$ from data, $t$ uniformly from $\{1,\ldots,T\}$, and $\epsilon \sim \mathcal{N}(0,I)$.
2. Form $x_t=\sqrt{\bar{\alpha}_t}x_0+\sqrt{1-\bar{\alpha}_t}\epsilon$.
3. Train $\epsilon_\theta(x_t,t)$ to predict $\epsilon$ with mean squared error.

The sampling algorithm starts at Gaussian noise and iterates the learned denoising transition. With the $\epsilon$ parameterization, the mean can be written as:

$$
\mu_\theta(x_t,t)=
\frac{1}{\sqrt{\alpha_t}}
\left(
x_t-\frac{\beta_t}{\sqrt{1-\bar{\alpha}_t}}\epsilon_\theta(x_t,t)
\right).
$$

### Mathematical Structure

- Key definitions:
  - $x_0$: data sample.
  - $x_t$: noisy latent at diffusion time $t$.
  - $\beta_t$: fixed forward-process variance schedule.
  - $\alpha_t=1-\beta_t$ and $\bar{\alpha}_t=\prod_{s=1}^t\alpha_s$.
  - $q(x_{1:T}\mid x_0)$: fixed forward noising process.
  - $p_\theta(x_{0:T})$: learned reverse generative process.
  - $\tilde{\mu}_t(x_t,x_0)$ and $\tilde{\beta}_t$: closed-form posterior parameters of $q(x_{t-1}\mid x_t,x_0)$.
  - $\epsilon_\theta(x_t,t)$: neural network predicting the noise used to construct $x_t$.
- Key equations:
  - Forward posterior:

$$
q(x_{t-1}\mid x_t,x_0)
=
\mathcal{N}(x_{t-1};\tilde{\mu}_t(x_t,x_0),\tilde{\beta}_t I).
$$

  - Variational bound decomposition:

$$
L =
\mathbb{E}_q[
D_{\mathrm{KL}}(q(x_T\mid x_0)\|p(x_T))
+ \sum_{t>1}D_{\mathrm{KL}}(q(x_{t-1}\mid x_t,x_0)\|p_\theta(x_{t-1}\mid x_t))
- \log p_\theta(x_0\mid x_1)
].
$$

  - Simplified objective:

$$
L_{\mathrm{simple}}(\theta)
=
\mathbb{E}_{t,x_0,\epsilon}
\left[
\|\epsilon-\epsilon_\theta(\sqrt{\bar{\alpha}_t}x_0+\sqrt{1-\bar{\alpha}_t}\epsilon,t)\|^2
\right].
$$

- Formal claims:
  - The variational objective trains a finite-time latent-variable generative model whose reverse transitions approximate the true reverse diffusion conditionals.
  - Under the $\epsilon$ parameterization, the reverse update has the form of a Langevin-like denoising step.
  - The simplified noise-prediction loss resembles denoising score matching across multiple noise levels; this gives a bridge between diffusion probabilistic models and score-based generative modeling.
- What the theory actually supports: The paper gives algebraic equivalences and objective decompositions. It does not prove that the simplified objective is the maximum-likelihood optimum, nor does it prove convergence of the learned sampler to the data distribution. The strongest claims are empirical: the chosen parameterization and loss produce high-quality samples.

### Implementation Details

- Architecture: U-Net backbone based on an unmasked PixelCNN++/Wide ResNet style architecture, with group normalization and self-attention at the $16 \times 16$ resolution.
- Time conditioning: Transformer sinusoidal position embeddings for diffusion time $t$, injected into residual blocks.
- Forward schedule: $T=1000$ diffusion steps, with $\beta_t$ linearly increasing from $10^{-4}$ to $0.02$.
- Reverse variance: Experiments compare several choices. Fixed reverse-process variances are simple and effective; learned variances were unstable in the reported ablation.
- Training details: Adam optimizer, EMA of model parameters, random horizontal flips for most image datasets, dropout $0.1$ for CIFAR10 and no dropout for the larger image datasets.
- Model scale: CIFAR10 model around 35.7M parameters; 256-resolution CelebA-HQ and LSUN models around 114M parameters, with a larger LSUN Bedroom variant around 256M parameters.

## Experiments And Evaluation

### Evaluation Questions

- Can diffusion probabilistic models generate high-quality images, not merely define a clean likelihood-based framework?
- Does the $\epsilon$-prediction simplification improve sample quality over more direct reverse-mean parameterizations?
- How do sample quality and likelihood trade off?
- Does the learned reverse process have a meaningful progressive or coarse-to-fine structure?

### Datasets And Benchmarks

- Unconditional CIFAR10 at $32 \times 32$.
- CelebA-HQ at $256 \times 256$.
- LSUN Bedroom, Church, and Cat at $256 \times 256$.

### Baselines

- Earlier diffusion probabilistic model from [[Deep Unsupervised Learning using Nonequilibrium Thermodynamics]].
- GAN baselines, including BigGAN, SNGAN variants, ProgressiveGAN, StyleGAN, and StyleGAN2-style results.
- Likelihood-based generative models, including autoregressive models, flows, and VAEs.
- Score-matching / energy-based lines such as NCSN and energy-based models.

### Metrics

- Sample quality: Inception Score and FID for CIFAR10; FID for LSUN.
- Likelihood / compression: negative log likelihood in bits per dimension, interpreted as lossless codelength.
- Progressive coding: rate-distortion behavior measured as rate in bits per dimension and distortion by RMSE on the $[0,255]$ scale.

### Main Results

- CIFAR10: The best $L_{\mathrm{simple}}$ model reports Inception Score $9.46 \pm 0.11$ and FID $3.17$, with test NLL $\leq 3.75$ bits/dim.
- Reverse-process ablation: Predicting $\epsilon$ with $L_{\mathrm{simple}}$ dramatically improves sample quality over the baseline $\tilde{\mu}$ prediction with the true variational bound in the reported setup.
- LSUN: The method produces competitive $256 \times 256$ samples. Reported FIDs include LSUN Bedroom $6.36$ for the standard model and $4.90$ for the larger model, LSUN Church $7.89$, and LSUN Cat $19.75$.
- Likelihood tradeoff: Optimizing the true variational bound improves codelength, while the simplified objective yields better sample quality. This separates "good likelihood" from "good perceptual sample quality."
- Progressive generation: During reverse sampling, large-scale structure appears earlier and fine details appear later, supporting the paper's interpretation of diffusion sampling as progressive lossy decompression.

### Evidence Quality

- What is convincing:
  - The CIFAR10 and LSUN sample-quality numbers show that diffusion models can compete with strong image generators without adversarial training.
  - The ablation directly supports the importance of the $\epsilon$-prediction parameterization and simplified objective.
  - The variational-bound derivation cleanly links the method to a likelihood-based latent-variable model rather than only to heuristic denoising.
  - The progressive coding analysis gives a useful interpretation of why likelihood and perceptual quality diverge: many bits are spent on imperceptible details.
- What is weak:
  - Final sample quality is reported at the best FID over training, so the evaluation is not a pure fixed-checkpoint protocol.
  - The paper does not provide a broad hyperparameter sweep; several choices, including $T=1000$, are fixed without exhaustive search.
  - Sampling is slow because it requires roughly one neural network evaluation per reverse diffusion step.
  - The compression procedure is a proof of concept because the minimal-random-coding-style primitive is not practical for high-dimensional images.
  - The paper's likelihoods are not competitive with the strongest likelihood-based generative models, even though the samples are strong.

## Formal Claims, Evidence, And Interpretation

### Formal Claims

- Diffusion probabilistic models can be trained as latent-variable models through a tractable variational bound.
- With small Gaussian forward steps, a Gaussian reverse process is a reasonable parameterization for denoising transitions.
- The $\epsilon$-prediction parameterization turns reverse-process mean learning into a denoising objective that resembles denoising score matching over multiple noise scales.
- The reverse sampling algorithm resembles annealed Langevin dynamics, but with coefficients derived from the forward process rather than selected post hoc.

### Evidence From The Paper

- The algebraic derivation shows how the variational bound decomposes into KL terms between true and learned reverse conditionals.
- The ablation shows $\epsilon$-prediction plus $L_{\mathrm{simple}}$ gives much better sample quality than the tested $\tilde{\mu}$-prediction baseline.
- The CIFAR10 and LSUN results show that the method is empirically competitive in image generation.
- The rate-distortion and progressive-generation experiments support the interpretation of diffusion as progressive lossy decoding.

### Limitations Of The Evidence

- The equivalence to denoising score matching is an objective/parameterization connection, not a proof that the simplified objective optimizes likelihood or perceptual quality optimally.
- The paper does not isolate all factors behind sample quality: architecture, objective, noise schedule, model scale, EMA, and evaluation protocol all matter.
- The experiments are image-generation focused; claims about other modalities are forward-looking rather than established by this paper.

### My Interpretation

The central lesson is that the right intermediate prediction target can make a generative model tractable. Predicting clean pixels directly would force the network to solve an ambiguous reconstruction problem at high noise levels. Predicting the injected Gaussian noise gives a stable supervised target at every noise level while still defining a reverse generative transition. The method's elegance is that this practical target is not detached from probability modeling: it falls out of a particular parameterization of a variationally trained reverse chain.

## Related Work And Field Position

This is a selective map, not an exhaustive bibliography. The useful way to place [[DDPM]] is as the bridge between an older variational diffusion idea and the modern score/denoising/guidance/scaling ecosystem.

### Direct Predecessors

- [[Score Matching and Denoising Autoencoders]] and [[A Connection Between Score Matching and Denoising Autoencoders]]: established the link between denoising corrupted data and estimating gradients of log density. [[DDPM]] reused this idea through the $\epsilon$-prediction objective.
- [[Deep Unsupervised Learning using Nonequilibrium Thermodynamics]]: introduced the forward noising / learned reverse-chain latent-variable framework, but did not yet make diffusion models competitive with strong image generators.
- [[Generative Modeling by Estimating Gradients of the Data Distribution|NCSN]]: estimated scores at multiple noise levels and sampled with annealed Langevin dynamics. It is the closest pre-DDPM score-based cousin: strong score-modeling intuition, but without DDPM's direct finite-time variational training of the sampler.

### Competing Generative Modeling Lines At The Time

- GANs such as [[GAN]], [[Pro GAN]], BigGAN, and StyleGAN-style generators: strong perceptual image quality, adversarial training, no tractable likelihood.
- VAEs such as [[Auto-Encoding Variational Bayes]]: likelihood-based latent-variable modeling and amortized inference, but weaker perceptual sample quality in image generation.
- Autoregressive models: exact likelihood and strong density modeling, but slow sequential generation.
- Normalizing flows: exact likelihood and invertible sampling, but architectural constraints from invertibility and change-of-variables tractability.
- Energy-based and score-matching models: conceptually close through score estimation and Langevin sampling, but historically harder to train and evaluate as direct likelihood models.

### Post-DDPM Milestone Timeline

- 2020 - [[DDPM]]: made diffusion models a practical high-quality image generator. Its lasting pattern is fixed noising, U-Net denoising, time conditioning, $\epsilon$ prediction, and iterative reverse sampling.
- 2020 / 2021 - [[DDIM]]: showed that the same training objective can support non-Markovian and deterministic samplers, making sampling much faster and opening the path to ODE-style interpretations.
- 2021 - [[Generative Modeling through SDE]]: unified DDPM-style diffusion and score-based generative modeling as reverse-time SDEs, with probability-flow ODEs and predictor-corrector samplers.
- 2021 - [[Improved Denoising Diffusion Probabilistic Models]]: improved likelihood/sample-quality tradeoffs, learned reverse variances, faster sampling, and scaling behavior.
- 2021 - [[Diffusion Models Beat GANs on Image Synthesis]]: established diffusion models as state-of-the-art image generators, especially through architecture improvements and classifier guidance.
- 2021 / 2022 - [[GLIDE]], [[DALL-E 2]], and [[Imagen]]: moved diffusion into text-conditioned image generation, combining strong image diffusion decoders with large text or CLIP-style representations.
- 2021 / 2022 - [[LDM]] / latent diffusion: moved the diffusion process from pixel space into an autoencoder latent space, making high-resolution generation much cheaper and enabling the Stable Diffusion line.
- 2022 - [[Classifier-free Diffusion Guidance]]: removed the need for a separate classifier by mixing conditional and unconditional score estimates; this became the default guidance mechanism for conditional diffusion.
- 2022 - [[Elucidating the Design Space of Diffusion-Based Generative Models]]: separated noise parameterization, preconditioning, schedules, solvers, and training choices into a cleaner design space.
- 2022 / 2023 - [[Rectified Flow]] and [[Flow Matching]]: reframed generation as learning transport vector fields or continuous normalizing flows, partly absorbing diffusion into a broader path/flow-matching view.
- 2023 - [[DiT]]: replaced the U-Net backbone with transformer blocks over latent patches, making architecture scaling a central axis for diffusion models.
- 2023 - [[ControlNet]]: made spatial control practical by attaching trainable conditioning branches to large pretrained text-to-image diffusion backbones.
- 2023 - [[CM|Consistency Models]]: attacked the sequential sampling bottleneck by learning mappings that are consistent along diffusion/ODE trajectories, enabling one-step or few-step generation.

### Main Design Axes After DDPM

- Objective and parameterization: $\epsilon$ prediction, $x_0$ prediction, $v$ prediction, score prediction, consistency targets, and flow/velocity targets.
- Noise process and schedule: discrete DDPM chains, continuous-time SDEs, probability-flow ODEs, EDM-style preconditioning, rectified paths, and optimal-transport-inspired paths.
- Sampler: ancestral DDPM sampling, deterministic DDIM sampling, numerical SDE/ODE solvers, predictor-corrector methods, distillation, consistency sampling, and few-step solvers.
- Guidance and conditioning: classifier guidance, classifier-free guidance, text conditioning, image conditioning, spatial controls, inpainting masks, depth, edges, pose, and multi-condition control.
- Representation space: pixel-space diffusion, latent-space diffusion, cascaded super-resolution diffusion, CLIP-latent generation, and multimodal latent representations.
- Architecture: U-Net denoisers, attention-augmented U-Nets, latent U-Nets, transformer denoisers, and hybrid designs.
- Deployment pressure: speed, memory, controllability, editability, safety filters, licensing/data issues, and distillation for interactive generation.

### Field-Level Interpretation

[[DDPM]] did not finish the theory of diffusion models; it made the core recipe reliable enough for the field to optimize around it. Most later milestones can be read as changing one part of the recipe while keeping the same conceptual scaffold:

$$
\text{corrupt data}
\rightarrow
\text{learn a denoising or transport field}
\rightarrow
\text{run a generative trajectory from noise to data}.
$$

The main post-DDPM shift was from "can diffusion models generate good images?" to "how should we parameterize, condition, accelerate, scale, and control the generative trajectory?"

## Limitations And Failure Modes

- Sampling cost is high: $T=1000$ requires many sequential network evaluations, making generation much slower than one-shot GAN sampling.
- Likelihood is not the main strength: the best perceptual model has weaker NLL than strong likelihood-based models.
- Sample quality depends on objective weighting: the simplified objective improves FID but sacrifices likelihood optimality.
- The learned reverse process has no formal guarantee of exact convergence to the data distribution under finite model capacity and finite $T$.
- The Gaussian noising process is well suited to images but is still an inductive choice; the paper does not establish that it is optimal.
- Progressive lossy compression is interpretive rather than practical, because the coding primitive assumed by the algorithms is not tractable at image scale.
- The method inherits data biases and broader generative-model misuse risks, as noted in the broader impact discussion.

## What To Remember

- Core problem: Make diffusion probabilistic models produce high-quality image samples while retaining a likelihood-based latent-variable formulation.
- Core method: Use a fixed Gaussian forward process and learn a Gaussian reverse process, parameterized through a neural network that predicts the injected noise $\epsilon$ from $x_t$ and $t$.
- Core evidence: Strong CIFAR10 and LSUN sample quality, especially CIFAR10 FID $3.17$; ablation showing the practical importance of $\epsilon$ prediction and $L_{\mathrm{simple}}$; progressive coding analysis showing coarse-to-fine structure.
- Core limitation: Sampling is slow and the best sample-quality objective is not the best likelihood objective.
- Reusable pattern: Choose a solver-facing or model-facing latent target that makes learning easy while preserving the outer probabilistic structure.

## Taste Calibration

- Why this paper became influential: It made diffusion models a practical generative modeling recipe: a simple forward corruption process, a U-Net denoiser, a noise-prediction loss, and iterative reverse sampling. That recipe was easy to scale, modify, and combine with conditioning.
- What is technically elegant: The $\epsilon$ parameterization simultaneously simplifies training, connects to score matching, and yields a concrete sampling update. The paper's best idea is not just "add noise and remove it"; it is the alignment between training target, reverse-chain parameterization, and score-based interpretation.
- What is weaker or sloppier than expected: The empirical story is stronger than the theoretical one. The simplified objective is justified by derivation and ablation, but ultimately chosen because it works. Sampling cost is also treated as acceptable for the demonstration, even though it became a major bottleneck for later work.
- What survived into later work: Noise-prediction or closely related parameterizations, U-Net denoisers with time conditioning, fixed or designed noise schedules, iterative denoising samplers, and the bridge between diffusion and score-based modeling.
- What I would test before building on it: Whether a claimed improvement changes the denoising target, the noise schedule, the sampler, the model capacity, or the guidance/conditioning mechanism; otherwise gains can be hard to attribute. I would also check sample quality versus likelihood and sampling cost separately, because the paper shows these axes can move in different directions.
