(** * DSL benchmark: Gates *)

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

From Circom Require Import Circom Util Default Tuple LibTactics Simplify Repr.
From Circom.CircomLib Require Import Bitify.

Local Coercion N.of_nat : nat >-> N.
Local Coercion Z.of_nat : nat >-> Z.

Local Open Scope F_scope.

Definition f_and (x: F) (y: F) := x = 1%F /\ y = 1%F.
Definition f_or (x: F) (y: F) := x = 1%F \/ y = 1%F.
Definition f_not (x: F) := x = 0%F.
Definition f_nand (x: F) (y: F) := ~(x = 1%F /\ y = 1%F).
Definition f_nor (x: F) (y: F) := ~(x = 1%F \/ y = 1%F).
Definition f_xor (x: F) (y: F) := x <> y.

(** ** Proof obligations for AND *)

Lemma and_obligation1: forall (a : F) (b : F) (out : F),
    ((a = 0%F) \/ (a = 1%F)) ->
    ((b = 0%F) \/ (b = 1%F)) -> True ->
    (out = (a * b)) ->
    (((out = 0%F) \/ (out = 1%F)) /\
       (((out = 1%F) -> (f_and a b)) /\ ((out = 0%F) -> ~(f_and a b)))).
Proof.
  unwrap_C. unfold f_and. intros.
  intuit; try fqsatz.
  - left. fqsatz.
  - left. fqsatz.
  - left. fqsatz.
  - right. fqsatz.
Qed.

(** ** Proof obligations for OR *)

Lemma or_obligation1: forall (a : F) (b : F) (out : F),
    ((a = 0%F) \/ (a = 1%F)) ->
    ((b = 0%F) \/ (b = 1%F)) -> True ->
    (out = ((a + b) - (a * b))) ->
    (((out = 0%F) \/ (out = 1%F)) /\
       (((out = 1%F) -> (f_or a b)) /\ ((out = 0%F) -> ~(f_or a b)))).
Proof.
  unwrap_C. unfold f_or. intros.
  intuit; try fqsatz.
  - left. fqsatz.
  - right. fqsatz.
  - right. fqsatz.
  - right. fqsatz.
Qed.

(** ** Proof obligations for NOT *)

Lemma not_obligation1: forall (_in : F) (out : F),
    ((_in = 0%F) \/ (_in = 1%F)) -> True ->
    (out = ((_in + 1%F) - ((1 + 1)%F * _in))) ->
    (((out = 0%F) \/ (out = 1%F)) /\
       (((out = 1%F) -> (f_not _in)) /\ ((out = 0%F) -> ~(f_not _in)))).
Proof.
  unwrap_C. unfold f_not. intros.
  intuit; try fqsatz; [right | left]; fqsatz.
Qed.

(** ** Proof obligations for NAND *)

Lemma nand_obligation1: forall (a : F) (b : F) (out : F),
    ((a = 0%F) \/ (a = 1%F)) ->
    ((b = 0%F) \/ (b = 1%F)) -> True ->
    (out = (1%F - (a * b))) ->
    (((out = 0%F) \/ (out = 1%F)) /\
       (((out = 1%F) -> (f_nand a b)) /\ ((out = 0%F) -> ~(f_nand a b)))).
Proof.
  unwrap_C. unfold f_nand. intros.
  intuit; try fqsatz.
  - right. fqsatz.
  - right. fqsatz.
  - right. fqsatz.
  - left. fqsatz.
Qed.

(** ** Proof obligations for NOR *)

Lemma nor_obligation1: forall (a : F) (b : F) (out : F),
    ((a = 0%F) \/ (a = 1%F)) ->
    ((b = 0%F) \/ (b = 1%F)) -> True ->
    (out = ((((a * b) + 1%F) - a) - b)) ->
    (((out = 0%F) \/ (out = 1%F)) /\
       (((out = 1%F) -> (f_nor a b)) /\ ((out = 0%F) -> ~(f_nor a b)))).
Proof.
  unwrap_C. unfold f_nor. intros.
  intuit; try fqsatz.
  - right. fqsatz.
  - left. fqsatz.
  - left. fqsatz.
  - left. fqsatz.
Qed.

(** ** Proof obligations for XOR *)

Lemma xor_obligation1: forall (a : F) (b : F) (out : F),
    ((a = 0%F) \/ (a = 1%F)) ->
    ((b = 0%F) \/ (b = 1%F)) -> True ->
    (out = ((a + b) - ((1 + 1)%F * (a * b)))) ->
    (((out = 0%F) \/ (out = 1%F)) /\ (((out = 1%F) -> (f_xor a b)) /\ ((out = 0%F) -> ~(f_xor a b)))).
Proof.
  unwrap_C. unfold f_xor. intros.
  intuit; try fqsatz; subst; auto.
  - left. fqsatz.
  - right. fqsatz.
  - right. fqsatz.
  - left. fqsatz.
Qed.