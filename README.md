# HyperMorphic-State-Dependent-Representation-Geometry
HyperMorphic SDRG is a framework for systems that dynamically change their representation geometry, arithmetic, or computational rules while preserving recoverability, invariants, and causal consistency.


HyperMorphic State-Dependent Representation Geometry

HyperMorphic SDRG is a framework for computational systems that dynamically change their representation geometry, arithmetic, routing structure, or active computational law while preserving recoverability, invariants, and causal consistency.

⸻

Table of Contents

1. Core Idea
2. Formal HyperMorphic System
3. Representation Fibres
4. Recoverable Invariant Transport
5. Invariant Preservation
6. Safe Geometry Projection
7. SafeGear as an SDRG Mechanism
8. History-Dependent Geometry
9. Geometry Selection as an Optimization Problem
10. Multi-Geometry Expert Routing
11. Computational Holonomy
12. Invariant-Constrained Lawspace Dynamics
13. Stability Conditions
14. The HyperMorphic Objective
15. The Defining HyperMorphic Principle

⸻

1. Core Idea

State-Dependent Representation Geometry, or SDRG, is a framework in which the representation used by a computational system is itself dynamical.

A conventional dynamical system evolves only its state:

$$
x_{t+1}=F(x_t,u_t).
$$

An SDRG system evolves both its state and the geometry through which that state is represented:

$$
x_{t+1}=T_{G_t}(x_t,u_t),
$$

$$
G_{t+1}=\Phi(H_t).
$$

Here:

* $x_t\in\mathcal X$ is the system state.
* $u_t\in\mathcal U$ is an external input.
* $G_t\in\mathcal G$ is the active representation geometry.
* $H_t\in\mathcal H$ is the causal history state.
* $\Phi:\mathcal H\rightarrow\mathcal G$ is the geometry-selection map.

The central principle is that the system does not merely change its numerical state.

It may also change the:

* coordinates,
* metric,
* encoding,
* topology,
* basis,
* arithmetic,
* routing structure,
* memory organization,
* or computational law

through which that state is represented and interpreted.

⸻

2. Formal HyperMorphic System

A HyperMorphic SDRG system may be represented by the tuple

$$
\mathfrak H

\left(
\mathcal X,
\mathcal U,
\mathcal G,
\mathcal H,
\Phi,
T,
\Psi,
x_0,
H_0
\right).
$$

The system evolves according to

$$
G_t=\Phi(H_t),
$$

$$
x_{t+1}=T_{G_t}(x_t,u_t),
$$

$$
H_{t+1}

\Psi(H_t,x_{t+1},u_t,G_t).
$$

The complete augmented state is

$$
z_t=(x_t,H_t,G_t).
$$

Its evolution can therefore be written as a skew-product system:

$$
z_{t+1}

\mathcal F(z_t,u_t).
$$

Unlike a fixed dynamical system, the transition law acting on $x_t$ depends on the dynamically regenerated geometry $G_t$.

The resulting causal cycle is

$$
H_t
\longrightarrow
G_t
\longrightarrow
x_{t+1}
\longrightarrow
H_{t+1}.
$$

⸻

3. Representation Fibres

Let

$$
\pi:\mathcal E\rightarrow\mathcal X
$$

be a fibre bundle over the state space.

For each state $x\in\mathcal X$, the fibre

$$
\mathcal E_x=\pi^{-1}(x)
$$

contains the possible representations of $x$.

A representation map under geometry $G_t$ is

$$
E_{G_t}:\mathcal X\rightarrow\mathcal Z_{G_t},
$$

where $\mathcal Z_{G_t}$ is the geometry-dependent representation space.

The encoded state is

$$
z_t=E_{G_t}(x_t).
$$

A decoder

$$
D_{G_t}:\mathcal Z_{G_t}\rightarrow\mathcal X
$$

recovers the underlying state.

Exact recoverability requires

$$
D_{G_t}\circ E_{G_t}

\operatorname{id}_{\mathcal X}.
$$

Therefore,

$$
D_{G_t}\left(E_{G_t}(x)\right)=x
$$

for every admissible state $x$ and geometry $G_t$.

This separates the represented object from the particular geometry used to encode it.

⸻

4. Recoverable Invariant Transport

Suppose the geometry changes from $G_t$ to $G_{t+1}$.

A representation transport operator is

$$
P_{t\rightarrow t+1}:
\mathcal Z_{G_t}
\rightarrow
\mathcal Z_{G_{t+1}}.
$$

The transported representation is

$$
z_{t+1}

P_{t\rightarrow t+1}(z_t).
$$

The transport is exactly recoverable when

$$
D_{G_{t+1}}
\circ
P_{t\rightarrow t+1}
\circ
E_{G_t}

\operatorname{id}_{\mathcal X}.
$$

Equivalently,

$$
D_{G_{t+1}}
\left(
P_{t\rightarrow t+1}
\left(
E_{G_t}(x)
\right)
\right)

x.
$$

This condition permits the representation to change while preserving the identity of the underlying information.

Approximate Recovery

For approximate recovery, one may require

$$
d_{\mathcal X}
\left(
D_{G_{t+1}}
P_{t\rightarrow t+1}
E_{G_t}(x),
x
\right)
\leq
\varepsilon_t,
$$

where $\varepsilon_t$ is the transport error.

Over $T$ transitions, a simple accumulated error bound is

$$
d_{\mathcal X}(\hat x_T,x_T)
\leq
\sum_{t=0}^{T-1}
L_t\varepsilon_t,
$$

where $L_t$ captures the sensitivity of subsequent transformations to transport error.

A stronger contractive formulation may instead satisfy

$$
d_{\mathcal X}(\hat x_T,x_T)
\leq
\sum_{t=0}^{T-1}
\left(
\prod_{s=t+1}^{T-1}L_s
\right)
\varepsilon_t.
$$

⸻

5. Invariant Preservation

Let

$$
I_j:\mathcal X\rightarrow\mathbb R,
\qquad
j=1,\ldots,m
$$

be designated invariants.

An admissible geometry transformation must satisfy

$$
I_j(x_{t+1})=I_j(x_t)
$$

for exact invariants, or

$$
\left|
I_j(x_{t+1})-I_j(x_t)
\right|
\leq
\delta_j
$$

for approximately preserved invariants.

Define the invariant-violation vector

$$
\Delta I_t

\begin{bmatrix}
I_1(x_{t+1})-I_1(x_t)\
\vdots\
I_m(x_{t+1})-I_m(x_t)
\end{bmatrix}.
$$

A transformation is admissible when

$$
|\Delta I_t|_W
\leq
B_t,
$$

where $W$ is a weighting matrix and $B_t$ is the permitted invariant budget.

The weighted norm may be defined by

$$
|\Delta I_t|_W

\sqrt{
\Delta I_t^\top
W
\Delta I_t
}.
$$

The admissible geometry set is

$$
\mathcal G_{\mathrm{adm}}(H_t)

\left{
G\in\mathcal G:
\mathcal C_j(G,H_t)\leq0
\text{ for all }j
\right}.
$$

The geometry selector must obey

$$
\Phi(H_t)
\in
\mathcal G_{\mathrm{adm}}(H_t).
$$

The system may therefore adapt only within the region in which its required invariants remain controlled.

⸻

6. Safe Geometry Projection

An unconstrained geometry selector may propose

$$
\widetilde G_{t+1}

\widetilde\Phi(H_t).
$$

If the proposed geometry is not admissible, the system may project it into the admissible geometry set:

$$
G_{t+1}

\Pi_{\mathcal G_{\mathrm{adm}}(H_t)}
\left(
\widetilde G_{t+1}
\right).
$$

The projection may be defined by

$$
G_{t+1}

\arg\min_{G\in\mathcal G_{\mathrm{adm}}(H_t)}
d_{\mathcal G}
\left(
G,\widetilde G_{t+1}
\right).
$$

This gives the HyperMorphic system freedom to adapt while preventing unlawful geometry changes.

The projected system therefore follows

$$
H_t
\xrightarrow{\widetilde\Phi}
\widetilde G_{t+1}
\xrightarrow{\Pi_{\mathcal G_{\mathrm{adm}}}}
G_{t+1}.
$$

⸻

7. SafeGear as an SDRG Mechanism

A discrete SDRG geometry may be specified by a modular gear pair

$$
G_t=(b_t,m_t),
$$

where:

* $b_t$ is a modular multiplier,
* $m_t$ is a modulus.

The forward representation is

$$
r_t

E_{G_t}(v_t)

b_tv_t
\pmod{m_t}.
$$

Exact recovery requires

$$
\gcd(b_t,m_t)=1.
$$

Under this condition, the modular inverse $b_t^{-1}$ exists and satisfies

$$
b_t^{-1}b_t
\equiv
1
\pmod{m_t}.
$$

The original value is recovered by

$$
v_t

D_{G_t}(r_t)

b_t^{-1}r_t
\pmod{m_t}.
$$

Therefore,

$$
D_{G_t}\left(E_{G_t}(v_t)\right)

b_t^{-1}b_tv_t
\equiv
v_t
\pmod{m_t}.
$$

The geometry may change dynamically:

$$
G_{t+1}

(b_{t+1},m_{t+1})

\Phi(H_t),
$$

provided

$$
\gcd(b_{t+1},m_{t+1})=1.
$$

SafeGear is therefore a concrete example of state-dependent representation geometry with exact algebraic recoverability.

SafeGear Admissibility

The admissible modular geometry set is

$$
\mathcal G_{\mathrm{SafeGear}}

\left{
(b,m)\in\mathbb N^2:
\gcd(b,m)=1
\right}.
$$

A proposed gear pair may be repaired by searching for the nearest admissible multiplier:

$$
b_t^\star

\min
\left{
b\geq \widetilde b_t:
\gcd(b,m_t)=1
\right}.
$$

The repaired geometry is then

$$
G_t=(b_t^\star,m_t).
$$

⸻

8. History-Dependent Geometry

The causal history may be represented recursively:

$$
H_{t+1}

\Psi(H_t,x_{t+1},u_t).
$$

A finite-window history may be written as

$$
H_t

\left(
x_{t-W+1:t},
u_{t-W+1:t-1}
\right).
$$

Alternatively, a compressed recurrent history state may satisfy

$$
H_{t+1}

\sigma
\left(
A_HH_t
+
A_xx_{t+1}
+
A_uu_t
\right).
$$

The geometry is regenerated from this causal summary:

$$
G_{t+1}

\Phi(H_{t+1}).
$$

Two synchronized systems with equivalent histories satisfy

$$
H_t^{(A)}

H_t^{(B)}.
$$

They therefore regenerate the same geometry:

$$
\Phi\left(H_t^{(A)}\right)

\Phi\left(H_t^{(B)}\right).
$$

This permits history-synchronized encoding and decoding without permanently fixing the representation.

Wrong-History Rejection

If the decoder has an incorrect history,

$$
\widetilde H_t\neq H_t,
$$

then it may regenerate a different geometry:

$$
\Phi(\widetilde H_t)
\neq
\Phi(H_t).
$$

The resulting decoder may fail the recovery condition:

$$
D_{\Phi(\widetilde H_t)}
\left(
E_{\Phi(H_t)}(x)
\right)
\neq
x.
$$

This provides a mechanism for causal synchronization and wrong-state rejection.

⸻

9. Geometry Selection as an Optimization Problem

The active geometry may be chosen to minimize task loss together with safety, switching, and invariant costs:

$$
G_t^\star

\arg\min_{G\in\mathcal G_{\mathrm{adm}}(H_t)}
\left[
\mathcal L_t(G)
+
\lambda_{\mathrm{sw}}
d_{\mathcal G}(G,G_{t-1})
+
\lambda_{\mathrm{inv}}
\mathcal V_t(G)
\right].
$$

Here:

* $\mathcal L_t(G)$ is the task loss,
* $d_{\mathcal G}(G,G_{t-1})$ is the cost of changing geometry,
* $\mathcal V_t(G)$ measures invariant violation,
* $\lambda_{\mathrm{sw}}\geq0$ controls switching cost,
* $\lambda_{\mathrm{inv}}\geq0$ controls invariant penalties.

A possible invariant penalty is

$$
\mathcal V_t(G)

\sum_{j=1}^{m}
\max
\left(
0,
\left|
I_j(x_{t+1})-I_j(x_t)
\right|

\delta_j
\right).
$$

This formalizes the trade-off between:

* adaptability,
* stability,
* computational performance,
* recoverability,
* and invariant preservation.

⸻

10. Multi-Geometry Expert Routing

Suppose the system has $K$ geometry experts:

$$
\mathcal G

\left{
G^{(1)},
\ldots,
G^{(K)}
\right}.
$$

Each expert produces

$$
\hat y_t^{(k)}

f_{G^{(k)}}(x_t).
$$

The router assigns weights

$$
w_{t,k}

\frac{
\exp(-\eta R_{t,k})
}{
\sum_{j=1}^{K}
\exp(-\eta R_{t,j})
},
$$

where:

* $R_{t,k}$ is the estimated cumulative regret of expert $k$,
* $\eta>0$ is the routing sensitivity.

The combined output is

$$
\hat y_t

\sum_{k=1}^{K}
w_{t,k}\hat y_t^{(k)}.
$$

The geometry may be selected discretely by

$$
G_t

G^{\left(
\arg\max_k w_{t,k}
\right)}
$$

or represented as a weighted mixture.

A regret update may take the form

$$
R_{t+1,k}

\beta R_{t,k}
+
(1-\beta)\ell_{t,k},
$$

where $\ell_{t,k}$ is the current loss and $\beta\in[0,1)$ is a memory parameter.

This mechanism allows the system to move among:

* local geometries,
* global geometries,
* sparse geometries,
* recurrent geometries,
* modular geometries,
* task-specific geometries,
* and other specialized representation structures.

⸻

11. Computational Holonomy

Consider a closed sequence of representation geometries

$$
G_0
\rightarrow
G_1
\rightarrow
\cdots
\rightarrow
G_n

G_0.
$$

Let

$$
P_{i\rightarrow i+1}
$$

be the transport operator between consecutive geometries.

The closed-loop transport is

$$
\mathcal H_\gamma

P_{n-1\rightarrow n}
\cdots
P_{1\rightarrow2}
P_{0\rightarrow1}.
$$

Even though the system returns to its original geometry, the total transformation may satisfy

$$
\mathcal H_\gamma\neq I.
$$

The quantity

$$
\mathcal H_\gamma
$$

is the computational holonomy of the path $\gamma$.

It represents information stored in the path of representation changes rather than solely in the final state.

A holonomy-based memory variable may be defined by

$$
M_\gamma

\log
\left(
\mathcal H_\gamma
\right)
$$

when the matrix or operator logarithm is well defined.

The holonomy is trivial when

$$
\mathcal H_\gamma=I,
$$

and nontrivial when

$$
\mathcal H_\gamma\neq I.
$$

This provides a formal mechanism by which a system may return to the same apparent state while retaining information about the path it travelled.

⸻

12. Invariant-Constrained Lawspace Dynamics

SDRG can be generalized from changing representation geometry to changing computational laws.

Let

$$
\mathcal L

\left{
L^{(1)},
L^{(2)},
\ldots
\right}
$$

be a lawspace.

The active law is

$$
L_t

\Lambda(H_t).
$$

The state evolves as

$$
x_{t+1}

T_{L_t,G_t}(x_t,u_t).
$$

The selected law must belong to an admissible subset:

$$
L_t
\in
\mathcal L_{\mathrm{adm}}(H_t).
$$

The combined HyperMorphic evolution is

$$
H_t
\longrightarrow
(L_t,G_t)
\longrightarrow
x_{t+1}
\longrightarrow
H_{t+1}.
$$

The system may therefore change both its representation and its computational law while preserving designated invariants.

A combined selector may be written as

$$
(\Lambda,\Phi):
\mathcal H
\rightarrow
\mathcal L\times\mathcal G.
$$

The joint admissibility condition is

$$
(L_t,G_t)
\in
\mathcal A(H_t),
$$

where

$$
\mathcal A(H_t)
\subseteq
\mathcal L\times\mathcal G
$$

is the set of lawful law-geometry pairs.

⸻

13. Stability Conditions

A useful SDRG system should satisfy several forms of stability.

State Stability

For two trajectories,

$$
d_{\mathcal X}(x_{t+1},x_{t+1}’)
\leq
L_x
d_{\mathcal X}(x_t,x_t’)
+
L_G
d_{\mathcal G}(G_t,G_t’).
$$

Geometry Stability

$$
d_{\mathcal G}(G_{t+1},G_{t+1}’)
\leq
L_\Phi
d_{\mathcal H}(H_t,H_t’).
$$

History Stability

$$
d_{\mathcal H}(H_{t+1},H_{t+1}’)
\leq
L_H
d_{\mathcal H}(H_t,H_t’)
+
L_X
d_{\mathcal X}(x_{t+1},x_{t+1}’).
$$

These inequalities may be collected into a coupled sensitivity system:

$$
\begin{bmatrix}
d_{\mathcal X,t+1}\
d_{\mathcal H,t+1}\
d_{\mathcal G,t+1}
\end{bmatrix}
\leq
M
\begin{bmatrix}
d_{\mathcal X,t}\
d_{\mathcal H,t}\
d_{\mathcal G,t}
\end{bmatrix},
$$

where $M$ is a block matrix of coupled state, history, and geometry sensitivities.

If the combined Lipschitz operator is contractive, nearby trajectories remain controlled.

A sufficient schematic condition is

$$
\rho(M)<1,
$$

where $\rho(M)$ is the spectral radius of $M$.

Under this condition,

$$
M^t\rightarrow0
\qquad
\text{as}
\qquad
t\rightarrow\infty,
$$

and perturbations decay rather than grow without bound.

⸻

14. The HyperMorphic Objective

The complete objective of a HyperMorphic SDRG system may be written as

$$
\min_{\Phi,T,E,D}
\sum_{t=0}^{T-1}
\Big[
\mathcal L_{\mathrm{task}}(x_t,u_t,G_t)
+
\lambda_{\mathrm{rec}}
\mathcal L_{\mathrm{rec}}(t)
+
\lambda_{\mathrm{inv}}
\mathcal L_{\mathrm{inv}}(t)
+
\lambda_{\mathrm{sw}}
\mathcal L_{\mathrm{switch}}(t)
+
\lambda_{\mathrm{cmp}}
\mathcal L_{\mathrm{complexity}}(G_t)
\Big],
$$

subject to

$$
G_t
\in
\mathcal G_{\mathrm{adm}}(H_t).
$$

Recovery Loss

$$
\mathcal L_{\mathrm{rec}}(t)

d_{\mathcal X}
\left(
D_{G_t}(E_{G_t}(x_t)),
x_t
\right).
$$

Invariant Loss

$$
\mathcal L_{\mathrm{inv}}(t)

\sum_j
\left|
I_j(x_{t+1})-I_j(x_t)
\right|.
$$

Switching Loss

$$
\mathcal L_{\mathrm{switch}}(t)

d_{\mathcal G}(G_t,G_{t-1}).
$$

Geometry Complexity Loss

A simple complexity penalty may be

$$
\mathcal L_{\mathrm{complexity}}(G_t)

C(G_t),
$$

where $C(G_t)$ measures the description length, computational cost, dimensionality, or structural complexity of the active geometry.

The full objective balances:

1. task performance,
2. exact or approximate recovery,
3. invariant preservation,
4. switching stability,
5. and representation complexity.

⸻

15. The Defining HyperMorphic Principle

The HyperMorphic principle can be summarized as follows:

$$
\boxed{
\text{A system may change its representation geometry or active law}
}
$$

$$
\boxed{
\text{provided that recoverability, invariants, and causal consistency remain controlled.}
}
$$

In compact form,

$$
\boxed{
H_t
\xrightarrow{\Phi}
G_t
\xrightarrow{E_{G_t}}
z_t
\xrightarrow{P_{t\rightarrow t+1}}
z_{t+1}
\xrightarrow{D_{G_{t+1}}}
x_t
}
$$

with the recovery condition

$$
\boxed{
D_{G_{t+1}}
P_{t\rightarrow t+1}
E_{G_t}

\operatorname{id}_{\mathcal X}.
}
$$

This equation captures the central mathematical mechanism of HyperMorphic SDRG:

$$
\boxed{
\text{Change the representation without losing the represented object.}
}
$$

⸻

Conceptual Summary

A conventional system uses a fixed representational structure:

$$
x_{t+1}=F(x_t,u_t).
$$

A HyperMorphic system dynamically regenerates the structure through which computation occurs:

$$
H_t
\rightarrow
G_t
\rightarrow
x_{t+1}
\rightarrow
H_{t+1}.
$$

The representation may change, but the system remains constrained by:

* recoverability,
* invariant preservation,
* admissibility,
* stability,
* and causal synchronization.

The result is a framework for systems that can lawfully reconfigure how they represent, process, route, encode, and recover information.

⸻

Repository Description

HyperMorphic SDRG is a framework for systems that dynamically change their representation geometry, arithmetic, or computational rules while preserving recoverability, invariants, and causal consistency.

⸻

Keywords

State-Dependent Representation Geometry
HyperMorphic
Recoverable Invariant Transport
SafeGear
Computational Holonomy
Dynamic Representation
Adaptive Computation
Invariant-Constrained Lawspace Dynamics
Causal Geometry
Reversible Computation
