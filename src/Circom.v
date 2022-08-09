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

Require Import Circom.BabyJubjub.
(* Require Import Crypto.Util.Tuple. *)
(* Require Import Crypto.Util.Decidable Crypto.Util.Notations. *)
(* Require Import Coq.setoid_ring.Ring_theory Coq.setoid_ring.Field_theory Coq.setoid_ring.Field_tac. *)


Definition q := BabyJubjub.p.
Definition k := 253.

Fact prime_q: prime q.
Proof. exact BabyJubjub.is_prime. Qed.

Fact two_lt_q: 2 < q.
Proof. unfold q, BabyJubjub.p. lia. Qed.

Fact k_positive: 1 < k.
Proof. unfold k. lia. Qed.

Fact q_lb: 2^k < q.
Proof. unfold k, q, BabyJubjub.p. lia. Qed.

Global Ltac unwrap_C :=
    pose proof prime_q as prime_q;
    pose proof two_lt_q as two_lt_q;
    pose proof k_positive as k_positive;
    pose proof q_lb as q_lb.

Lemma q_gtb_1: (1 <? q)%positive = true.
Proof.
  unwrap_C.
  apply Pos.ltb_lt. lia.
Qed.

Lemma q_gt_2: 2 < q.
Proof.
  unwrap_C.
  replace 2%Z with (2^1)%Z by lia.
  apply Z.le_lt_trans with (m := (2 ^ k)%Z); try lia.
  eapply Zpow_facts.Zpower_le_monotone; try lia.
Qed.

Global Hint Rewrite q_gtb_1 : circom.
Global Hint Rewrite two_lt_q : circom.
Global Ltac fqsatz := fsatz_safe; autorewrite with circom; auto.

Definition lt (x y: F q) := F.to_Z x < F.to_Z y.
Definition leq (x y: F q) := F.to_Z x <= F.to_Z y.
Definition lt_z (x: F q) y := F.to_Z x <= y.
Definition leq_z (x: F q) y := F.to_Z x <= y.

(* TODO: replace this Ltac with destruct;intuition *)
Global Ltac split_eqns :=
  repeat match goal with
  | [ |- _ /\ _ ] => split
  | [ H: exists _, _ |- _ ] => destruct H
  | [ H: {s | _ } |- _ ] => destruct H
  | [ H: _ /\ _ |- _ ] => destruct H
  | [ _: _ |- _ -> _ ] => intros
  end.

Declare Scope circom_scope.
Delimit Scope circom_scope with circom.

Global Infix "<z" := Circom.lt_z (at level 50) : circom_scope.
Global Infix "<=z" := Circom.leq_z (at level 50) : circom_scope.
Global Notation "a >z b" := (Circom.lt_z b a) (at level 50) : circom_scope.
Global Notation "a >=z b" := (Circom.leq_z b a) (at level 50) : circom_scope.

Global Infix "<q" := Circom.lt (at level 50) : circom_scope.
Global Infix "<=q" := Circom.leq (at level 50) : circom_scope.
Global Notation "a >q b" := (Circom.lt b a) (at level 50) : circom_scope.
Global Notation "a >=q b" := (Circom.leq b a) (at level 50) : circom_scope.
Global Notation F := (F q).
Global Notation "2" := (F.add 1 1 : F) : circom_scope.