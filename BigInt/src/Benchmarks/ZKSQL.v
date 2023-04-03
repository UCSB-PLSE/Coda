(** * DSL benchmark: ZK-SQL *)

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

From Circom Require Import Circom Util Default Tuple ListUtil LibTactics Simplify Repr.
From Circom.CircomLib Require Import Bitify.

Local Coercion N.of_nat : nat >-> N.
Local Coercion Z.of_nat : nat >-> Z.

Local Open Scope list_scope.
Local Open Scope F_scope.
Local Open Scope Z_scope.
Local Open Scope circom_scope.
Local Open Scope tuple_scope.

Definition f_not (x: F) := x = 0%F.

(** ** CalculateTotal *)

(* print_endline (generate_lemmas calc_total (typecheck_circuit d_empty calc_total));; *)

Lemma CalculateTotal_obligation0_trivial: forall (n : nat) (_in : (list F)) (v : Z), Forall (fun x0 => True) _in -> ((length _in) = n) -> True -> ((v = 0%nat) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation1_trivial: forall (n : nat) (_in : (list F)) (v : Z), Forall (fun x1 => True) _in -> ((length _in) = n) -> True -> (((0%nat <= v) /\ (v = n)) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation2_trivial: forall (n : nat) (_in : (list F)) (v : Z), Forall (fun x2 => True) _in -> ((length _in) = n) -> True -> (((0%nat <= v) /\ (v < n)) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation3_trivial: forall (n : nat) (_in : (list F)) (i : nat) (v : F), Forall (fun x3 => True) _in -> ((length _in) = n) -> (i < n) -> True -> ((v = (sum (take i _in))) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation4_trivial: forall (n : nat) (_in : (list F)) (i : nat) (x : F) (v : F), Forall (fun x4 => True) _in -> ((length _in) = n) -> (i < n) -> (x = (sum (take i _in))) -> True -> (((v = (sum (take i _in))) /\ (v = x)) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation5_trivial: forall (n : nat) (_in : (list F)) (i : nat) (x : F) (v : F), Forall (fun x5 => True) _in -> ((length _in) = n) -> (i < n) -> (x = (sum (take i _in))) -> True -> ((v = (_in!i)) -> True).
Proof. intuit. Qed.

Lemma CalculateTotal_obligation6: forall (n : nat) (_in : (list F)) (i : nat) (x : F) (v : F), Forall (fun x6 => True) _in -> ((length _in) = n) -> (i < n) -> (x = (sum (take i _in))) -> True -> ((v = (x + (_in!i))%F) -> (v = (sum (take (i + 1%nat)%nat _in)))).
Proof. Admitted.

Lemma CalculateTotal_obligation7: forall (n : nat) (_in : (list F)) (v : F), Forall (fun x7 => True) _in -> ((length _in) = n) -> True -> ((v = 0%F) -> (v = (sum (take 0%nat _in)))).
Proof. Admitted.

Lemma CalculateTotal_obligation8: forall (n : nat) (_in : (list F)) (v : F), Forall (fun x8 => True) _in -> ((length _in) = n) -> True -> ((v = (sum (take n _in))) -> (v = (sum _in))).
Proof. Admitted.

(** ** SumEquals *)

(* print_endline (generate_lemmas sum_equals (typecheck_circuit (add_to_deltas d_empty [is_equal; calc_total]) sum_equals));; *)

Lemma SumEquals_obligation0: forall (n : nat) (nums : (list F)) (sum : F) (v : Z), Forall (fun x24 => True) nums -> ((length nums) = n) -> True -> True -> (((0%nat <= v) /\ (v = n)) -> (0%nat <= v)).
Proof. Admitted.

Lemma SumEquals_obligation1: forall (n : nat) (nums : (list F)) (sum : F) (v : (list F)), Forall (fun x25 => True) nums -> ((length nums) = n) -> True -> Forall (fun x26 => True) v -> True -> ((((length v) = n) /\ (v = nums)) -> ((length v) = n)).
Proof. Admitted.

Lemma SumEquals_obligation2_trivial: forall (n : nat) (nums : (list F)) (sum : F) (x : F) (v : F), Forall (fun x27 => True) nums -> ((length nums) = n) -> True -> (x = (sum nums)) -> True -> (((v = (sum nums)) /\ (v = x)) -> True).
Proof. intuit. Qed.

Lemma SumEquals_obligation3_trivial: forall (n : nat) (nums : (list F)) (sum : F) (x : F) (v : F), Forall (fun x28 => True) nums -> ((length nums) = n) -> True -> (x = (sum nums)) -> True -> ((v = sum) -> True).
Proof. intuit. Qed.

Lemma SumEquals_obligation4: forall (n : nat) (nums : (list F)) (sum : F) (x : F) (v : F), Forall (fun x29 => True) nums -> ((length nums) = n) -> True -> (x = (sum nums)) -> True -> ((((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (x = sum)) /\ ((v = 0%F) -> ~(x = sum)))) -> ((v = 0%F) \/ (v = 1%F))).
Proof. Admitted.

(** ** IsNotZero *)

(* print_endline (generate_lemmas is_not_zero (typecheck_circuit (add_to_deltas d_empty [cnot; is_zero]) is_not_zero));; *)

Lemma IsNotZero_obligation0_trivial: forall (_in : F) (v : F), True -> True -> ((v = _in) -> True).
Proof. intuit. Qed.

Lemma IsNotZero_obligation1: forall (_in : F) (isz : F) (v : F), True -> (((isz = 0%F) \/ (isz = 1%F)) /\ (((isz = 1%F) -> (_in = 0%F)) /\ ((isz = 0%F) -> ~(_in = 0%F)))) -> True -> (((((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (_in = 0%F)) /\ ((v = 0%F) -> ~(_in = 0%F)))) /\ (v = isz)) -> ((v = 0%F) \/ (v = 1%F))).
Proof. intuit. Qed.

Lemma IsNotZero_obligation2: forall (_in : F) (isz : F) (v : F), True -> (((isz = 0%F) \/ (isz = 1%F)) /\ (((isz = 1%F) -> (_in = 0%F)) /\ ((isz = 0%F) -> ~(_in = 0%F)))) -> True -> ((((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> (f_not isz)) /\ ((v = 0%F) -> ~(f_not isz)))) -> (((v = 0%F) \/ (v = 1%F)) /\ (((v = 1%F) -> ~(_in = 0%F)) /\ ((v = 0%F) -> ~~(_in = 0%F))))).
Proof. intuit. Qed.

(** ** IsFiltered *)

(* print_endline (generate_lemmas is_filtered (typecheck_circuit (add_to_deltas d_empty [is_equal; calc_total]) is_filtered));; *)

(* TODO *)