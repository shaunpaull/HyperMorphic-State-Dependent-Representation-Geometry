import Mathlib

/-!
# HyperMorphic State-Dependent Representation Geometry

A single-file Lean 4 formalization of the core HyperMorphic SDRG mechanisms:

* dynamical state-dependent representation geometry;
* exact encode/decode recoverability;
* canonical recoverable transport between geometries;
* invariant preservation and admissible geometry selection;
* safe projection into an admissible geometry set;
* history synchronization;
* multi-geometry routing;
* computational holonomy;
* invariant-constrained lawspace dynamics;
* abstract stability and loss certificates;
* SafeGear modular winding over `ZMod` using units.

The file intentionally distinguishes between:

1. executable definitions;
2. contracts carried as proof fields;
3. theorems derived from those contracts.

The concrete SafeGear model represents admissibility with `(ZMod m)ˣ`. Because a
multiplier is stored as a unit, the existence of its inverse is guaranteed by the
type system rather than checked after the fact.
-/

universe uX uU uG uH uR uE uL

namespace HyperMorphic

/-! ## 1. Core SDRG system -/

/--
A HyperMorphic state-dependent representation geometry system.

`Rep g` is the representation space associated with geometry `g`.
`decode_encode` is the fundamental exact-recoverability contract.
-/
structure SDRG where
  State : Type uX
  Input : Type uU
  Geometry : Type uG
  History : Type uH
  Rep : Geometry → Type uR

  selector : History → Geometry
  transition : (g : Geometry) → State → Input → State
  updateHistory : History → State → Input → Geometry → History

  encode : (g : Geometry) → State → Rep g
  decode : (g : Geometry) → Rep g → State

  decode_encode :
    ∀ (g : Geometry) (x : State), decode g (encode g x) = x

namespace SDRG

/-- The computational configuration; the active geometry is regenerated from history. -/
structure Config (S : SDRG) where
  state : S.State
  history : S.History

/-- Regenerate the active geometry from the current causal history. -/
def activeGeometry (S : SDRG) (c : Config S) : S.Geometry :=
  S.selector c.history

/-- One HyperMorphic evolution step. -/
def step (S : SDRG) (c : Config S) (u : S.Input) : Config S :=
  let g := S.selector c.history
  let xNext := S.transition g c.state u
  let hNext := S.updateHistory c.history xNext u g
  ⟨xNext, hNext⟩

/-- Exact recovery within a fixed representation geometry. -/
@[simp] theorem roundTrip
    (S : SDRG) (g : S.Geometry) (x : S.State) :
    S.decode g (S.encode g x) = x :=
  S.decode_encode g x

/--
Canonical transport from geometry `g₁` to geometry `g₂`:
decode the old representation, then encode the recovered state in the new geometry.
-/
def transport
    (S : SDRG)
    (g₁ g₂ : S.Geometry)
    (z : S.Rep g₁) : S.Rep g₂ :=
  S.encode g₂ (S.decode g₁ z)

/-- Canonical transport preserves the represented state exactly. -/
@[simp] theorem transport_recovers
    (S : SDRG)
    (g₁ g₂ : S.Geometry)
    (x : S.State) :
    S.decode g₂ (S.transport g₁ g₂ (S.encode g₁ x)) = x := by
  simp [transport, S.decode_encode]

/-- Canonical transports compose coherently. -/
@[simp] theorem transport_comp
    (S : SDRG)
    (g₁ g₂ g₃ : S.Geometry)
    (z : S.Rep g₁) :
    S.transport g₂ g₃ (S.transport g₁ g₂ z) =
      S.transport g₁ g₃ z := by
  simp [transport, S.decode_encode]

/-- Transporting an encoded state directly equals re-encoding it in the target geometry. -/
@[simp] theorem transport_encode
    (S : SDRG)
    (g₁ g₂ : S.Geometry)
    (x : S.State) :
    S.transport g₁ g₂ (S.encode g₁ x) = S.encode g₂ x := by
  simp [transport, S.decode_encode]

/-- Equal causal histories regenerate equal representation geometries. -/
theorem synchronized_geometry
    (S : SDRG)
    {hA hB : S.History}
    (h : hA = hB) :
    S.selector hA = S.selector hB := by
  exact congrArg S.selector h

/--
A wrong-history rejection property for systems whose cross-geometry decoder can
return failure. This is an application-level security contract, not something
every SDRG system must satisfy automatically.
-/
def RejectsWrongHistory
    (S : SDRG)
    (crossDecode :
      (gAttempt gActual : S.Geometry) → S.Rep gActual → Option S.State) : Prop :=
  ∀ (hCorrect hWrong : S.History),
    hCorrect ≠ hWrong →
    ∀ (x : S.State),
      crossDecode
          (S.selector hWrong)
          (S.selector hCorrect)
          (S.encode (S.selector hCorrect) x) = none

end SDRG

/-! ## 2. Invariants and admissibility -/

/-- Exact preservation of a state observable by one geometry-specific transition. -/
def PreservesInvariant
    (S : SDRG)
    {V : Type uE}
    (I : S.State → V)
    (g : S.Geometry) : Prop :=
  ∀ (x : S.State) (u : S.Input),
    I (S.transition g x u) = I x

/-- Approximate preservation of a real-valued state observable. -/
def ApproximatelyPreservesInvariant
    (S : SDRG)
    (I : S.State → ℝ)
    (ε : ℝ)
    (g : S.Geometry) : Prop :=
  ∀ (x : S.State) (u : S.Input),
    |I (S.transition g x u) - I x| ≤ ε

/-- An admissible geometry predicate together with proof that the selector obeys it. -/
structure Admissibility (S : SDRG) where
  allowed : S.History → S.Geometry → Prop
  selector_allowed : ∀ h, allowed h (S.selector h)

namespace Admissibility

/-- The SDRG selector always returns an admissible geometry. -/
@[simp] theorem selected_is_allowed
    (S : SDRG)
    (A : Admissibility S)
    (h : S.History) :
    A.allowed h (S.selector h) :=
  A.selector_allowed h

end Admissibility

/--
A safe projection layer: an unconstrained proposal is projected into the
admissible geometry set.
-/
structure SafeProjection
    (S : SDRG)
    (A : Admissibility S) where
  propose : S.History → S.Geometry
  project : (h : S.History) → S.Geometry → S.Geometry
  projected_allowed : ∀ h g, A.allowed h (project h g)

namespace SafeProjection

/-- Select a proposal and immediately project it into the admissible set. -/
def safeGeometry
    (S : SDRG)
    (A : Admissibility S)
    (P : SafeProjection S A)
    (h : S.History) : S.Geometry :=
  P.project h (P.propose h)

/-- Safe projection returns an admissible geometry by construction. -/
@[simp] theorem safeGeometry_allowed
    (S : SDRG)
    (A : Admissibility S)
    (P : SafeProjection S A)
    (h : S.History) :
    A.allowed h (safeGeometry S A P h) := by
  exact P.projected_allowed h (P.propose h)

end SafeProjection

/--
`g` is an admissible global minimizer of a history-dependent geometry cost.
This is the proposition-level counterpart of an `argmin` expression.
-/
def IsOptimalGeometry
    (S : SDRG)
    (A : Admissibility S)
    (cost : S.History → S.Geometry → ℝ)
    (h : S.History)
    (g : S.Geometry) : Prop :=
  A.allowed h g ∧
    ∀ g', A.allowed h g' → cost h g ≤ cost h g'

/-! ## 3. Multi-geometry routing -/

/--
An abstract expert router. `choose_maximal` certifies that the selected expert
has maximal score among all experts represented by this router.
-/
structure GeometryRouter (S : SDRG) where
  Expert : Type uE
  geometry : Expert → S.Geometry
  score : S.History → Expert → ℝ
  choose : S.History → Expert
  choose_maximal : ∀ h e, score h e ≤ score h (choose h)

namespace GeometryRouter

/-- Geometry selected by the active expert. -/
def routedGeometry
    (S : SDRG)
    (R : GeometryRouter S)
    (h : S.History) : S.Geometry :=
  R.geometry (R.choose h)

/-- The chosen expert has score at least as large as every alternative expert. -/
theorem chosen_score_maximal
    (S : SDRG)
    (R : GeometryRouter S)
    (h : S.History)
    (e : R.Expert) :
    R.score h e ≤ R.score h (R.choose h) :=
  R.choose_maximal h e

end GeometryRouter

/-- Exponential-moving-average regret update used by adaptive routers. -/
def emaRegret (β oldRegret newLoss : ℝ) : ℝ :=
  β * oldRegret + (1 - β) * newLoss

/-! ## 4. Computational holonomy -/

/-- Apply a path of endomorphisms in path order. -/
def pathTransport {α : Type uX} : List (α → α) → α → α
  | [], x => x
  | f :: fs, x => pathTransport fs (f x)

@[simp] theorem pathTransport_nil
    {α : Type uX} (x : α) :
    pathTransport ([] : List (α → α)) x = x :=
  rfl

@[simp] theorem pathTransport_cons
    {α : Type uX}
    (f : α → α)
    (fs : List (α → α))
    (x : α) :
    pathTransport (f :: fs) x = pathTransport fs (f x) :=
  rfl

/-- Path concatenation corresponds to functional transport composition. -/
theorem pathTransport_append
    {α : Type uX}
    (p q : List (α → α))
    (x : α) :
    pathTransport (p ++ q) x = pathTransport q (pathTransport p x) := by
  induction p generalizing x with
  | nil => rfl
  | cons f fs ih =>
      simp [pathTransport, ih]

/-- Computational holonomy of a closed transport path. -/
def holonomy {α : Type uX} (path : List (α → α)) : α → α :=
  pathTransport path

/-- A path has nontrivial holonomy when it changes at least one represented state. -/
def NontrivialHolonomy {α : Type uX} (path : List (α → α)) : Prop :=
  ∃ x, holonomy path x ≠ x

@[simp] theorem empty_holonomy
    {α : Type uX} :
    holonomy ([] : List (α → α)) = id := by
  funext x
  rfl

/-! ## 5. Invariant-constrained lawspace dynamics -/

/--
A lawspace extension of an existing SDRG system.
The active computational law is regenerated from causal history and certified
as admissible.
-/
structure LawspaceExtension (S : SDRG) where
  Law : Type uL
  lawSelector : S.History → Law
  lawAllowed : S.History → Law → Prop
  selectedLaw_allowed : ∀ h, lawAllowed h (lawSelector h)
  evolve : Law → (g : S.Geometry) → S.State → S.Input → S.State

namespace LawspaceExtension

/-- One joint law-and-geometry evolution step. -/
def lawStep
    (S : SDRG)
    (L : LawspaceExtension S)
    (c : S.Config)
    (u : S.Input) : S.Config :=
  let g := S.selector c.history
  let law := L.lawSelector c.history
  let xNext := L.evolve law g c.state u
  let hNext := S.updateHistory c.history xNext u g
  ⟨xNext, hNext⟩

/-- The active law is admissible by the extension contract. -/
@[simp] theorem activeLaw_allowed
    (S : SDRG)
    (L : LawspaceExtension S)
    (h : S.History) :
    L.lawAllowed h (L.lawSelector h) :=
  L.selectedLaw_allowed h

end LawspaceExtension

/-! ## 6. Stability and objective certificates -/

/--
An abstract Lipschitz-style stability certificate for coupled state, history,
and geometry evolution.
-/
structure StabilityCertificate (S : SDRG) where
  dState : S.State → S.State → ℝ
  dHistory : S.History → S.History → ℝ
  dGeometry : S.Geometry → S.Geometry → ℝ

  Lx : ℝ
  Lg : ℝ
  Lphi : ℝ
  Lh : ℝ
  LstateToHistory : ℝ

  state_bound :
    ∀ g g' x x' u,
      dState (S.transition g x u) (S.transition g' x' u) ≤
        Lx * dState x x' + Lg * dGeometry g g'

  geometry_bound :
    ∀ h h',
      dGeometry (S.selector h) (S.selector h') ≤
        Lphi * dHistory h h'

  history_bound :
    ∀ h h' x x' u g g',
      dHistory
          (S.updateHistory h x u g)
          (S.updateHistory h' x' u g') ≤
        Lh * dHistory h h' +
          LstateToHistory * dState x x'

/-- Loss terms and weights for a HyperMorphic one-step objective. -/
structure LossModel (S : SDRG) where
  taskLoss : S.State → S.Input → S.Geometry → ℝ
  recoveryLoss : S.State → S.Geometry → ℝ
  invariantLoss : S.State → S.State → ℝ
  switchingLoss : S.Geometry → S.Geometry → ℝ
  complexityLoss : S.Geometry → ℝ

  lambdaRecovery : ℝ
  lambdaInvariant : ℝ
  lambdaSwitching : ℝ
  lambdaComplexity : ℝ

/-- Weighted one-step HyperMorphic objective. -/
def oneStepObjective
    (S : SDRG)
    (L : LossModel S)
    (x xNext : S.State)
    (u : S.Input)
    (gPrev g : S.Geometry) : ℝ :=
  L.taskLoss x u g +
    L.lambdaRecovery * L.recoveryLoss x g +
    L.lambdaInvariant * L.invariantLoss x xNext +
    L.lambdaSwitching * L.switchingLoss gPrev g +
    L.lambdaComplexity * L.complexityLoss g

/-! ## 7. SafeGear: concrete modular SDRG -/

namespace SafeGear

/--
A lawful modular gear over `ZMod m`.

The multiplier is a unit, so invertibility is guaranteed by construction.
-/
structure Gear (m : ℕ) where
  multiplier : (ZMod m)ˣ

/-- SafeGear forward winding. -/
def encode {m : ℕ} (g : Gear m) (v : ZMod m) : ZMod m :=
  (g.multiplier : ZMod m) * v

/-- SafeGear inverse winding. -/
def decode {m : ℕ} (g : Gear m) (r : ZMod m) : ZMod m :=
  (↑(g.multiplier⁻¹) : ZMod m) * r

/-- The inverse winding exactly recovers the original value. -/
@[simp] theorem decode_encode
    {m : ℕ}
    (g : Gear m)
    (v : ZMod m) :
    decode g (encode g v) = v := by
  unfold decode encode
  rw [← mul_assoc]
  simp

/-- The forward SafeGear winding is injective. -/
theorem encode_injective
    {m : ℕ}
    (g : Gear m) :
    Function.Injective (encode g) := by
  intro a b h
  have h' := congrArg (decode g) h
  simpa using h'

/-- SafeGear winding is a bijection. -/
theorem encode_bijective
    {m : ℕ}
    (g : Gear m) :
    Function.Bijective (encode g) := by
  constructor
  · exact encode_injective g
  · intro r
    refine ⟨decode g r, ?_⟩
    unfold encode decode
    rw [← mul_assoc]
    simp

/-- Integer coprimality is the source-level SafeGear admissibility predicate. -/
def Admissible (b : ℤ) (m : ℕ) : Prop :=
  IsCoprime b (m : ℤ)

/-- Construct a lawful gear from an integer proven coprime to the modulus. -/
def ofIsCoprime
    {m : ℕ}
    (b : ℤ)
    (h : IsCoprime b (m : ℤ)) : Gear m :=
  ⟨ZMod.unitOfIsCoprime b h⟩

/-- The coprime constructor has the expected forward multiplication semantics. -/
@[simp] theorem encode_ofIsCoprime
    {m : ℕ}
    (b : ℤ)
    (h : IsCoprime b (m : ℤ))
    (v : ZMod m) :
    encode (ofIsCoprime b h) v = (b : ZMod m) * v := by
  simp [encode, ofIsCoprime]

/-- A coprime integer multiplier gives exact modular recovery. -/
@[simp] theorem coprime_roundTrip
    {m : ℕ}
    (b : ℤ)
    (h : IsCoprime b (m : ℤ))
    (v : ZMod m) :
    decode (ofIsCoprime b h) (encode (ofIsCoprime b h) v) = v := by
  exact decode_encode (ofIsCoprime b h) v

/--
Interpret SafeGear as a complete SDRG instance.

* state: a residue in `ZMod m`;
* geometry/history: the current lawful modular gear;
* representation: a wound residue;
* transition: identity in this minimal mechanism model;
* recovery: the SafeGear round-trip theorem.
-/
def asSDRG (m : ℕ) : SDRG where
  State := ZMod m
  Input := Unit
  Geometry := Gear m
  History := Gear m
  Rep := fun _ => ZMod m

  selector := id
  transition := fun _ x _ => x
  updateHistory := fun h _ _ _ => h

  encode := fun g x => SafeGear.encode g x
  decode := fun g z => SafeGear.decode g z

  decode_encode := by
    intro g x
    exact SafeGear.decode_encode g x

/-- SafeGear transport between two lawful gears recovers the same residue. -/
@[simp] theorem transport_between_gears_recovers
    {m : ℕ}
    (g₁ g₂ : Gear m)
    (v : ZMod m) :
    let S := asSDRG m
    S.decode g₂ (S.transport g₁ g₂ (S.encode g₁ v)) = v := by
  simp [asSDRG, SDRG.transport, SafeGear.decode_encode]

end SafeGear

/-! ## 8. Top-level defining theorem -/

/--
The defining HyperMorphic statement:
canonical geometry change preserves the represented object exactly whenever
each geometry satisfies the SDRG encode/decode contract.
-/
theorem change_representation_without_losing_object
    (S : SDRG)
    (gOld gNew : S.Geometry)
    (x : S.State) :
    S.decode gNew
      (S.transport gOld gNew (S.encode gOld x)) = x := by
  exact S.transport_recovers gOld gNew x

end HyperMorphic
