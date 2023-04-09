(** * DSL benchmark: ZK-SBT *)

Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
Require Import Coq.Init.Peano.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Arith.Compare_dec.
Require Import Coq.PArith.BinPosDef.
Require Import Coq.ZArith.BinInt Coq.ZArith.ZArith Coq.ZArith.Zdiv Coq.ZArith.Znumtheory Coq.NArith.NArith. (* import Zdiv before Znumtheory *)
Require Import Coq.NArith.Nnat.

Require Import Crypto.Spec.ModularArithmetic.
Require Import Crypto.Arithmetic.PrimeFieldTheorems Crypto.Algebra.Field.
Require Import Crypto.Util.Decidable. (* Crypto.Util.Notations. *)
Require Import Coq.setoid_ring.Ring_theory Coq.setoid_ring.Field_theory Coq.setoid_ring.Field_tac.

From Circom Require Import Circom Util Default Tuple ListUtil LibTactics Simplify Repr Coda.
From Circom.CircomLib Require Import Bitify.

Local Coercion N.of_nat : nat >-> N.
Local Coercion Z.of_nat : nat >-> Z.

Local Open Scope list_scope.
Local Open Scope F_scope.
Local Open Scope Z_scope.
Local Open Scope circom_scope.
Local Open Scope tuple_scope.

Notation "3" := (1 + 1 + 1)%F.
Notation "4" := (1 + 1 + 1 + 1)%F.
Notation "5" := (1 + 1 + 1 + 1 + 1)%F.

Definition Poseidon (nInputs : nat) (inputs : list F) : F := 0.

(** ** IN *)

(* print_endline (generate_lemmas "IN" (typecheck_circuit (add_to_deltas d_empty [is_equal; greater_than]) c_in));; *)

Lemma IN_obligation0_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (v : Z), True -> Forall (fun x28 => True) value -> ((length value) = valueArraySize) -> True -> ((v = 0%nat) -> True).
Proof. intuit. Qed.

Lemma IN_obligation1_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (v : Z), True -> Forall (fun x29 => True) value -> ((length value) = valueArraySize) -> True -> (((v = valueArraySize) /\ True) -> True).
Proof. intuit. Qed.

Lemma IN_obligation2_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (v : Z), True -> Forall (fun x30 => True) value -> ((length value) = valueArraySize) -> True -> (((0%nat <= v) /\ (v < valueArraySize)) -> True).
Proof. intuit. Qed.

Lemma IN_obligation3_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (v : F), True -> Forall (fun x31 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> True -> ((((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((v = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> True).
Proof. intuit. Qed.

Lemma IN_obligation4_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (x : F) (v : F), True -> Forall (fun x32 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> (((x = 0%F) \/ (x = 1%F)) /\ (((x = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((x = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> True -> (((v = _in) /\ True) -> True).
Proof. intuit. Qed.

Lemma IN_obligation5_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (x : F) (v : F), True -> Forall (fun x33 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> (((x = 0%F) \/ (x = 1%F)) /\ (((x = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((x = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> True -> ((v = (value!i)) -> True).
Proof. intuit. Qed.

Lemma IN_obligation6_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (x : F) (ise : F) (v : F), True -> Forall (fun x34 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> (((x = 0%F) \/ (x = 1%F)) /\ (((x = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((x = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> (((ise = 0%F) \/ (ise = 1%F)) /\ (((ise = 1%F) -> (_in = (value!i))) /\ ((ise = 0%F) -> ~(_in = (value!i))))) -> True -> (((v = x) /\ True) -> True).
Proof. intuit. Qed.

Lemma IN_obligation7_trivial: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (x : F) (ise : F) (v : F), True -> Forall (fun x35 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> (((x = 0%F) \/ (x = 1%F)) /\ (((x = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((x = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> (((ise = 0%F) \/ (ise = 1%F)) /\ (((ise = 1%F) -> (_in = (value!i))) /\ ((ise = 0%F) -> ~(_in = (value!i))))) -> True -> (((v = ise) /\ True) -> True).
Proof. intuit. Qed.

Lemma IN_obligation8: forall (valueArraySize : nat) (_in : F) (value : (list F)) (i : nat) (x : F) (ise : F) (v : F), True -> Forall (fun x36 => True) value -> ((length value) = valueArraySize) -> (i < valueArraySize) -> (((x = 0%F) \/ (x = 1%F)) /\ (((x = 1%F) -> (exists (j:nat), 0%nat <= j < i -> ((value!j) = _in))) /\ ((x = 0%F) -> ~((exists (j:nat), 0%nat <= j < i -> ((value!j) = _in)))))) -> (((ise = 0%F) \/ (ise = 1%F)) /\ (((ise = 1%F) -> (_in = (value!i))) /\ ((ise = 0%F) -> ~(_in = (value!i))))) -> True -> ((v = (x + ise)%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (exists (j:nat), 0%nat <= j < (i + 1%nat)%nat -> ((value!j) = _in))) /\ ((v = 0%F) -> ~((exists (j:nat), 0%nat <= j < (i + 1%nat)%nat -> ((value!j) = _in))))))).
Proof. Admitted.

Lemma IN_obligation9: forall (valueArraySize : nat) (_in : F) (value : (list F)) (v : F), True -> Forall (fun x37 => True) value -> ((length value) = valueArraySize) -> True -> ((v = 0%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (exists (j:nat), 0%nat <= j < 0%nat -> ((value!j) = _in))) /\ ((v = 0%F) -> ~((exists (j:nat), 0%nat <= j < 0%nat -> ((value!j) = _in))))))).
Proof. Admitted.

Lemma IN_obligation10: forall (valueArraySize : nat) (_in : F) (value : (list F)) (count : F) (v : Z), True -> Forall (fun x38 => True) value -> ((length value) = valueArraySize) -> (((count = 0%F) \/ (count = 1%F)) /\ (((count = 1%F) -> (exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))) /\ ((count = 0%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))))) -> True -> ((v = 252%nat) -> ((0%nat <= v) /\ (v <= (C.k - 1%nat)%Z))).
Proof. Admitted.

Lemma IN_obligation11: forall (valueArraySize : nat) (_in : F) (value : (list F)) (count : F) (v : F), True -> Forall (fun x39 => True) value -> ((length value) = valueArraySize) -> (((count = 0%F) \/ (count = 1%F)) /\ (((count = 1%F) -> (exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))) /\ ((count = 0%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))))) -> True -> (((v = count) /\ True) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma IN_obligation12: forall (valueArraySize : nat) (_in : F) (value : (list F)) (count : F) (v : F), True -> Forall (fun x40 => True) value -> ((length value) = valueArraySize) -> (((count = 0%F) \/ (count = 1%F)) /\ (((count = 1%F) -> (exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))) /\ ((count = 0%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))))) -> True -> ((v = 0%F) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma IN_obligation13: forall (valueArraySize : nat) (_in : F) (value : (list F)) (count : F) (v : F), True -> Forall (fun x41 => True) value -> ((length value) = valueArraySize) -> (((count = 0%F) \/ (count = 1%F)) /\ (((count = 1%F) -> (exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))) /\ ((count = 0%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))))) -> True -> ((((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> ((^ 0%F) < (^ count))) /\ ((v = 0%F) -> ~((^ 0%F) < (^ count))))) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((v = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))))))).
Proof. Admitted.

(** ** Query *)

(* print_endline (generate_lemmas "Query" (typecheck_circuit (add_to_deltas d_empty [num2bits; is_equal; less_than; greater_than; mux3; c_in]) query));; *)

Lemma Query_obligation0_trivial: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x42 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> True -> (((v = _in) /\ True) -> True).
Proof. intuit. Qed.

Lemma Query_obligation1_trivial: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x43 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> True -> (((v = x) /\ True) -> True).
Proof. intuit. Qed.

Lemma Query_obligation2: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (v : Z), (0%nat < valueArraySize) -> True -> Forall (fun x44 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> True -> ((v = 252%nat) -> ((0%nat <= v) /\ (v <= (C.k - 1%nat)%Z))).
Proof. Admitted.

Lemma Query_obligation3: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x45 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> True -> (((v = _in) /\ True) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma Query_obligation4: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x46 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> True -> (((v = x) /\ True) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma Query_obligation5: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (v : Z), (0%nat < valueArraySize) -> True -> Forall (fun x47 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> True -> ((v = 252%nat) -> ((0%nat <= v) /\ (v <= (C.k - 1%nat)%Z))).
Proof. Admitted.

Lemma Query_obligation6: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x48 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> True -> (((v = _in) /\ True) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma Query_obligation7: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x49 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> True -> (((v = x) /\ True) -> ((^ v) < (2%nat ^ 252%nat)%Z)).
Proof. Admitted.

Lemma Query_obligation8: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (v : Z), (0%nat < valueArraySize) -> True -> Forall (fun x50 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> True -> (((v = valueArraySize) /\ True) -> (0%nat <= v)).
Proof. lia. Qed.

Lemma Query_obligation9_trivial: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x51 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> True -> (((v = _in) /\ True) -> True).
Proof. intuit. Qed.

Lemma Query_obligation10: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (v : (list F)), (0%nat < valueArraySize) -> True -> Forall (fun x52 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> Forall (fun x53 => True) v -> True -> (((v = value) /\ True) -> (Z.of_nat (length v) = valueArraySize)).
Proof.
  intuit; subst; lia.
Qed.

Lemma Query_obligation11: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (v : Z), (0%nat < valueArraySize) -> True -> Forall (fun x54 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> True -> ((v = 3%nat) -> (0%nat <= v)).
Proof. lia. Qed.

Lemma Query_obligation12_trivial: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x55 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> True -> (((v = operator) /\ True) -> True).
Proof. intuit. Qed.

Lemma Query_obligation13: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (n2b : (list F)) (v : (list F)), (0%nat < valueArraySize) -> True -> Forall (fun x56 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> Forall (fun x57 => ((x57 = 0%F) \/ (x57 = 1%F))) n2b -> (((as_le_f n2b) = operator) /\ ((length n2b) = 3%nat)) -> Forall (fun x58 => True) v -> True -> ((((((((((True /\ ((v!0%nat) = 1%F)) /\ ((v!1%nat) = eq)) /\ ((v!2%nat) = lt)) /\ ((v!3%nat) = gt)) /\ ((v!4%nat) = _in)) /\ ((v!5%nat) = (1%F - _in)%F)) /\ ((v!6%nat) = 0%F)) /\ ((v!7%nat) = 0%F)) /\ ((length v) = 8%nat)) -> ((length v) = 8%nat)).
Proof. intuit. Qed.

Lemma Query_obligation14: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (n2b : (list F)) (v : (list F)), (0%nat < valueArraySize) -> True -> Forall (fun x59 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> Forall (fun x60 => ((x60 = 0%F) \/ (x60 = 1%F))) n2b -> (((as_le_f n2b) = operator) /\ ((length n2b) = 3%nat)) -> Forall (fun x61 => True) v -> True -> (((v = n2b) /\ True) -> ((length v) = 3%nat)).
Proof.
  intuit; subst; auto.
Qed.

Lemma Query_obligation15: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (n2b : (list F)) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x62 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> Forall (fun x63 => ((x63 = 0%F) \/ (x63 = 1%F))) n2b -> (((as_le_f n2b) = operator) /\ ((length n2b) = 3%nat)) -> True -> (True -> ((v = 0%F) \/ (v = 1%F))).
Proof. Admitted.

Lemma Query_obligation16: forall (valueArraySize : Z) (_in : F) (value : (list F)) (operator : F) (x : F) (eq : F) (lt : F) (gt : F) (_in : F) (n2b : (list F)) (v : F), (0%nat < valueArraySize) -> True -> Forall (fun x64 => True) value -> (Z.of_nat (length value) = valueArraySize) -> True -> (x = (value!0%nat)) -> (((eq = 0%F) \/ (eq = 1%F)) /\ (((eq = 1%F) -> (_in = x)) /\ ((eq = 0%F) -> ~(_in = x)))) -> (((lt = 0%F) \/ (lt = 1%F)) /\ (((lt = 1%F) -> ((^ _in) < (^ x))) /\ ((lt = 0%F) -> ~((^ _in) < (^ x))))) -> (((gt = 0%F) \/ (gt = 1%F)) /\ (((gt = 1%F) -> ((^ x) < (^ _in))) /\ ((gt = 0%F) -> ~((^ x) < (^ _in))))) -> (((_in = 0%F) \/ (_in = 1%F)) /\ (((_in = 1%F) -> (exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in))) /\ ((_in = 0%F) -> ~((exists (i:nat), 0%nat <= i < (length value) -> ((value!i) = _in)))))) -> Forall (fun x65 => ((x65 = 0%F) \/ (x65 = 1%F))) n2b -> (((as_le_f n2b) = operator) /\ ((length n2b) = 3%nat)) -> True -> ((v = ((1%F :: (eq :: (lt :: (gt :: (_in :: ((1%F - _in)%F :: (0%F :: (0%F :: nil))))))))! Z.to_nat (^ (as_le_f n2b)))) -> (((operator = 0%F) -> (v = 1%F)) /\ (~((operator = 0%F)) -> (((operator = 1%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (_in = (value!0%nat))) /\ ((v = 0%F) -> ~(_in = (value!0%nat)))))) /\ (~((operator = 1%F)) -> (((operator = 2%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> ((^ _in) < (^ (value!0%nat)))) /\ ((v = 0%F) -> ~((^ _in) < (^ (value!0%nat))))))) /\ (~((operator = 2%F)) -> (((operator = 3%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> ((^ (value!0%nat)) < (^ _in))) /\ ((v = 0%F) -> ~((^ (value!0%nat)) < (^ _in)))))) /\ (~((operator = 3%F)) -> (((operator = 4%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))) /\ ((v = 0%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in))))))) /\ (~((operator = 4%F)) -> (((operator = 5%F) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> ~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))) /\ ((v = 0%F) -> ~(~((exists (j:nat), 0%nat <= j < valueArraySize -> ((value!j) = _in)))))))) /\ (~((operator = 5%F)) -> False))))))))))))).
Proof. Admitted.

(** ** getValueByIndex *)

(* print_endline (generate_lemmas "getValueByIndex" (typecheck_circuit (add_to_deltas d_empty [num2bits; mux3]) get_val_by_idx));; *)

(* TODO *)

(** ** getIdenState *)

(* print_endline (generate_lemmas "getIdenState" (typecheck_circuit (add_to_delta d_empty poseidon) get_iden_state));; *)

Lemma getIdenState_obligation0: forall (claimsTreeRoot : F) (revTreeRoot : F) (rootsTreeRoot : F) (z : (list F)) (v : Z), True -> True -> True -> Forall (fun x66 => True) z -> ((((True /\ ((z!0%nat) = claimsTreeRoot)) /\ ((z!1%nat) = revTreeRoot)) /\ ((z!2%nat) = rootsTreeRoot)) /\ ((length z) = 3%nat)) -> True -> ((v = 3%nat) -> (0%nat <= v)).
Proof. lia. Qed.

Lemma getIdenState_obligation1: forall (claimsTreeRoot : F) (revTreeRoot : F) (rootsTreeRoot : F) (z : (list F)) (v : (list F)), True -> True -> True -> Forall (fun x67 => True) z -> ((((True /\ ((z!0%nat) = claimsTreeRoot)) /\ ((z!1%nat) = revTreeRoot)) /\ ((z!2%nat) = rootsTreeRoot)) /\ ((length z) = 3%nat)) -> Forall (fun x68 => True) v -> True -> (((v = z) /\ True) -> ((length v) = 3%nat)).
Proof.
  intuit; subst; auto.
Qed.

Lemma getIdenState_obligation2: forall (claimsTreeRoot : F) (revTreeRoot : F) (rootsTreeRoot : F) (z : (list F)) (v : F), True -> True -> True -> Forall (fun x69 => True) z -> ((((True /\ ((z!0%nat) = claimsTreeRoot)) /\ ((z!1%nat) = revTreeRoot)) /\ ((z!2%nat) = rootsTreeRoot)) /\ ((length z) = 3%nat)) -> True -> ((v = (Poseidon 3%nat z)) -> (v = (Poseidon 3%nat (claimsTreeRoot :: (revTreeRoot :: (rootsTreeRoot :: nil)))))).
Proof. auto. Qed.

(** ** cutId *)

(* print_endline (generate_lemmas "cutId" (typecheck_circuit (add_to_deltas d_empty [num2bits; bits2num]) cut_id));; *)

(* TODO *)

(** ** cutState *)

(* print_endline (generate_lemmas "cutSt" (typecheck_circuit (add_to_deltas d_empty [num2bits; bits2num]) cut_st));; *)

(* TODO *)
