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

Local Coercion N.of_nat : nat >->
  N.
Local Coercion Z.of_nat : nat >->
  Z.

Local Open Scope list_scope.
Local Open Scope F_scope.
Local Open Scope Z_scope.
Local Open Scope circom_scope.
Local Open Scope tuple_scope.

Definition Poseidon (nInputs : nat)
  (inputs : list F) : F. Admitted.

Axiom Poseidon_2 : forall inputs : list F,
  length inputs = 2%nat ->
  Poseidon 2%nat inputs = Poseidon 2%nat ((inputs!0%nat)::(inputs!1%nat)::nil).

#[global]Hint Extern 10 (Forall _ (firstn _ _)) => apply Forall_firstn: core.
#[global]Hint Extern 10  => match goal with
   | [ |- context[List_nth_Default _ _] ] => unfold_default end: core.
   #[global]Hint Extern 10  => match goal with
   | [ |- context[List.nth  _ _ _] ] => apply Forall_nth end: core.
#[global]Hint Extern 10 => match goal with
  [ |- context[length _] ] => rewrite_length end: core.
#[global]Hint Extern 10 (Forall _ (skipn _ _)) => apply Forall_skipn: core.

#[global]Hint Extern 10 (Forall _ (_ :: _)) => constructor: core.
#[global]Hint Extern 10 (Z.of_N (N.of_nat _)) => rewrite nat_N_Z: core.
#[global]Hint Extern 10  => repeat match goal with
  [ H: context[Z.of_N (N.of_nat _)] |- _] => rewrite nat_N_Z in H end: core.

#[global]Hint Extern 10 (_ < _) => lia: core.
#[global]Hint Extern 10 (_ < _)%nat => lia: core.
#[global]Hint Extern 10 (_ <= _) => lia: core.
#[global]Hint Extern 10 (_ <= _)%nat => lia: core.
#[global]Hint Extern 10 (_ > _) => lia: core.
#[global]Hint Extern 10 (_ > _)%nat => lia: core.
#[global]Hint Extern 10 (_ >= _) => lia: core.
#[global]Hint Extern 10 (_ >= _)%nat => lia: core.
#[global]Hint Extern 10 (S _ = S _) => f_equal: core.

Definition zip {A B} (xs : list A)
  (ys : list B) := combine xs ys.

(* Note: This is a placeholder implementation that lets us prove many
trivial and even some nontrivial MerkleTreeInclusionProof obligations *)
Definition MrklTreeInclPfHash (xs : list (F * F))
  (init : F) := 
  fold_left (fun (y:F)
  (x:(F*F)) => if dec (fst x = 0%F) then (Poseidon 2%nat (y :: (snd x) :: nil)) else (Poseidon 2%nat ((snd x):: y :: nil))) 
                        xs init.

Definition CalculateIdentityCommitment a := Poseidon 1%nat (a :: nil).

Definition CalculateSecret a b := Poseidon 2%nat (a :: (b :: nil)).

Definition CalculateNullifierHash a b := Poseidon 2%nat (a :: (b :: nil)).

Definition MerkleTreeInclusionProof i a b := MrklTreeInclPfHash (zip a b) i.

#[global]Hint Extern 10 (Forall _ (firstn _ _)) => apply Forall_firstn: core.
#[global]Hint Extern 10  => match goal with
   | [ |- context[List_nth_Default _ _] ] => unfold_default end: core.
   #[global]Hint Extern 10  => match goal with
   | [ |- context[List.nth  _ _ _] ] => apply Forall_nth end: core.
#[global]Hint Extern 10 => match goal with
  [ |- context[length _] ] => rewrite_length end: core.
#[global]Hint Extern 10 (Forall _ (skipn _ _)) => apply Forall_skipn: core.

#[global]Hint Extern 10 (Forall _ (_ :: _)) => constructor: core.
#[global]Hint Extern 10 (Z.of_N (N.of_nat _)) => rewrite nat_N_Z: core.
#[global]Hint Extern 10  => repeat match goal with
  [ H: context[Z.of_N (N.of_nat _)] |- _] => rewrite nat_N_Z in H end: core.

#[global]Hint Extern 10 (_ < _) => lia: core.
#[global]Hint Extern 10 (_ < _)%nat => lia: core.
#[global]Hint Extern 10 (_ <= _) => lia: core.
#[global]Hint Extern 10 (_ <= _)%nat => lia: core.
#[global]Hint Extern 10 (_ > _) => lia: core.
#[global]Hint Extern 10 (_ > _)%nat => lia: core.
#[global]Hint Extern 10 (_ >= _) => lia: core.
#[global]Hint Extern 10 (_ >= _)%nat => lia: core.
#[global]Hint Extern 10 (S _ = S _) => f_equal: core.

(* Source: https://github.com/iden3/circomlib/blob/master/circuits/mux1.circom *)
(* Source: https://github.com/semaphore-protocol/semaphore/blob/main/packages/circuits/tree.circom *)
(* Source: https://github.com/semaphore-protocol/semaphore/blob/main/packages/circuits/semaphore.circom *)

Module Semaphore_new.

Lemma Semaphore_obligation322: forall 
  (signalHash : F)
  (externalNullifier : F)
  (identityNullifier : F)
  (identityTrapdoor : F)
  (treePathIndices_0 : F)
  (treePathIndices_1 : F)
  (treePathIndices_2 : F)
  (treePathIndices_3 : F)
  (treePathIndices_4 : F)
  (treePathIndices_5 : F)
  (treePathIndices_6 : F)
  (treePathIndices_7 : F)
  (treePathIndices_8 : F)
  (treePathIndices_9 : F)
  (treePathIndices_10 : F)
  (treePathIndices_11 : F)
  (treePathIndices_12 : F)
  (treePathIndices_13 : F)
  (treePathIndices_14 : F)
  (treePathIndices_15 : F)
  (treePathIndices_16 : F)
  (treePathIndices_17 : F)
  (treePathIndices_18 : F)
  (treePathIndices_19 : F)
  (treeSiblings_0 : F)
  (treeSiblings_1 : F)
  (treeSiblings_2 : F)
  (treeSiblings_3 : F)
  (treeSiblings_4 : F)
  (treeSiblings_5 : F)
  (treeSiblings_6 : F)
  (treeSiblings_7 : F)
  (treeSiblings_8 : F)
  (treeSiblings_9 : F)
  (treeSiblings_10 : F)
  (treeSiblings_11 : F)
  (treeSiblings_12 : F)
  (treeSiblings_13 : F)
  (treeSiblings_14 : F)
  (treeSiblings_15 : F)
  (treeSiblings_16 : F)
  (treeSiblings_17 : F)
  (treeSiblings_18 : F)
  (treeSiblings_19 : F)
  (calculateSecret_identityNullifier : F)
  (calculateSecret_identityTrapdoor : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (poseidon_out : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (calculateSecret_out : F)
  (secret : F)
  (calculateIdentityCommitment_secret : F)
  (poseidon_inputs_0 : F)
  (poseidon_out : F)
  (poseidon_inputs_1 : F)
  (poseidon_inputs_0 : F)
  (calculateIdentityCommitment_out : F)
  (calculateNullifierHash_externalNullifier : F)
  (calculateNullifierHash_identityNullifier : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (poseidon_out : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (calculateNullifierHash_out : F)
  (inclusionProof_leaf : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_pathIndices_0 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_pathIndices_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_pathIndices_2 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_pathIndices_3 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_pathIndices_4 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_pathIndices_5 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_pathIndices_6 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_pathIndices_7 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_pathIndices_8 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_pathIndices_9 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_pathIndices_10 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_pathIndices_11 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_pathIndices_12 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_pathIndices_13 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_pathIndices_14 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_pathIndices_15 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_pathIndices_16 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_pathIndices_17 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_pathIndices_18 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_hashes_0 : F)
  (_assertion_1 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_1 : F)
  (_assertion_2 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_2 : F)
  (_assertion_3 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_3 : F)
  (_assertion_4 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_4 : F)
  (_assertion_5 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_5 : F)
  (_assertion_6 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_6 : F)
  (_assertion_7 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_7 : F)
  (_assertion_8 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_8 : F)
  (_assertion_9 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_9 : F)
  (_assertion_10 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_10 : F)
  (_assertion_11 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_11 : F)
  (_assertion_12 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_12 : F)
  (_assertion_13 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_13 : F)
  (_assertion_14 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_14 : F)
  (_assertion_15 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_15 : F)
  (_assertion_16 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_16 : F)
  (_assertion_17 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_17 : F)
  (_assertion_18 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_18 : F)
  (_assertion_19 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_19 : F)
  (_assertion_20 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_20 : F)
  (inclusionProof_root : F)
  (root : F)
  (signalHashSquared : F)
  (nullifierHash : F)
  (v : F), (calculateSecret_identityNullifier = identityNullifier) ->
  (calculateSecret_identityTrapdoor = identityTrapdoor) ->
  ((poseidon_inputs_0 = identityNullifier) /\ (poseidon_inputs_0 = calculateSecret_identityNullifier)) ->
  ((poseidon_inputs_1 = identityTrapdoor) /\ (poseidon_inputs_1 = calculateSecret_identityTrapdoor)) ->
  (calculateSecret_out = poseidon_out) ->
  ((secret = poseidon_out) /\ (secret = calculateSecret_out)) ->
  (((calculateIdentityCommitment_secret = poseidon_out) /\ (calculateIdentityCommitment_secret = calculateSecret_out)) /\ (calculateIdentityCommitment_secret = secret)) ->
  ((((poseidon_inputs_0 = poseidon_out) /\ (poseidon_inputs_0 = calculateSecret_out)) /\ (poseidon_inputs_0 = secret)) /\ (poseidon_inputs_0 = calculateIdentityCommitment_secret)) ->
  (calculateIdentityCommitment_out = poseidon_out) ->
  (calculateNullifierHash_externalNullifier = externalNullifier) ->
  (calculateNullifierHash_identityNullifier = identityNullifier) ->
  ((poseidon_inputs_0 = externalNullifier) /\ (poseidon_inputs_0 = calculateNullifierHash_externalNullifier)) ->
  ((poseidon_inputs_1 = identityNullifier) /\ (poseidon_inputs_1 = calculateNullifierHash_identityNullifier)) ->
  (calculateNullifierHash_out = poseidon_out) ->
  ((inclusionProof_leaf = poseidon_out) /\ (inclusionProof_leaf = calculateIdentityCommitment_out)) ->
  (inclusionProof_siblings_0 = treeSiblings_0) ->
  (inclusionProof_pathIndices_0 = treePathIndices_0) ->
  (inclusionProof_siblings_1 = treeSiblings_1) ->
  (inclusionProof_pathIndices_1 = treePathIndices_1) ->
  (inclusionProof_siblings_2 = treeSiblings_2) ->
  (inclusionProof_pathIndices_2 = treePathIndices_2) ->
  (inclusionProof_siblings_3 = treeSiblings_3) ->
  (inclusionProof_pathIndices_3 = treePathIndices_3) ->
  (inclusionProof_siblings_4 = treeSiblings_4) ->
  (inclusionProof_pathIndices_4 = treePathIndices_4) ->
  (inclusionProof_siblings_5 = treeSiblings_5) ->
  (inclusionProof_pathIndices_5 = treePathIndices_5) ->
  (inclusionProof_siblings_6 = treeSiblings_6) ->
  (inclusionProof_pathIndices_6 = treePathIndices_6) ->
  (inclusionProof_siblings_7 = treeSiblings_7) ->
  (inclusionProof_pathIndices_7 = treePathIndices_7) ->
  (inclusionProof_siblings_8 = treeSiblings_8) ->
  (inclusionProof_pathIndices_8 = treePathIndices_8) ->
  (inclusionProof_siblings_9 = treeSiblings_9) ->
  (inclusionProof_pathIndices_9 = treePathIndices_9) ->
  (inclusionProof_siblings_10 = treeSiblings_10) ->
  (inclusionProof_pathIndices_10 = treePathIndices_10) ->
  (inclusionProof_siblings_11 = treeSiblings_11) ->
  (inclusionProof_pathIndices_11 = treePathIndices_11) ->
  (inclusionProof_siblings_12 = treeSiblings_12) ->
  (inclusionProof_pathIndices_12 = treePathIndices_12) ->
  (inclusionProof_siblings_13 = treeSiblings_13) ->
  (inclusionProof_pathIndices_13 = treePathIndices_13) ->
  (inclusionProof_siblings_14 = treeSiblings_14) ->
  (inclusionProof_pathIndices_14 = treePathIndices_14) ->
  (inclusionProof_siblings_15 = treeSiblings_15) ->
  (inclusionProof_pathIndices_15 = treePathIndices_15) ->
  (inclusionProof_siblings_16 = treeSiblings_16) ->
  (inclusionProof_pathIndices_16 = treePathIndices_16) ->
  (inclusionProof_siblings_17 = treeSiblings_17) ->
  (inclusionProof_pathIndices_17 = treePathIndices_17) ->
  (inclusionProof_siblings_18 = treeSiblings_18) ->
  (inclusionProof_pathIndices_18 = treePathIndices_18) ->
  (inclusionProof_siblings_19 = treeSiblings_19) ->
  (inclusionProof_pathIndices_19 = treePathIndices_19) ->
  (((inclusionProof_hashes_0 = poseidon_out) /\ (inclusionProof_hashes_0 = calculateIdentityCommitment_out)) /\ (inclusionProof_hashes_0 = inclusionProof_leaf)) ->
  ((inclusionProof_pathIndices_0 * (1%F - inclusionProof_pathIndices_0)%F)%F = 0%F) ->
  ((((mux_c_0_0 = poseidon_out) /\ (mux_c_0_0 = calculateIdentityCommitment_out)) /\ (mux_c_0_0 = inclusionProof_leaf)) /\ (mux_c_0_0 = inclusionProof_hashes_0)) ->
  ((mux_c_0_1 = treeSiblings_0) /\ (mux_c_0_1 = inclusionProof_siblings_0)) ->
  ((mux_c_1_0 = treeSiblings_0) /\ (mux_c_1_0 = inclusionProof_siblings_0)) ->
  ((((mux_c_1_1 = poseidon_out) /\ (mux_c_1_1 = calculateIdentityCommitment_out)) /\ (mux_c_1_1 = inclusionProof_leaf)) /\ (mux_c_1_1 = inclusionProof_hashes_0)) ->
  ((mux_s = treePathIndices_0) /\ (mux_s = inclusionProof_pathIndices_0)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_1 = poseidons_out) ->
  ((inclusionProof_pathIndices_1 * (1%F - inclusionProof_pathIndices_1)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_1)) ->
  ((mux_c_0_1 = treeSiblings_1) /\ (mux_c_0_1 = inclusionProof_siblings_1)) ->
  ((mux_c_1_0 = treeSiblings_1) /\ (mux_c_1_0 = inclusionProof_siblings_1)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_1)) ->
  ((mux_s = treePathIndices_1) /\ (mux_s = inclusionProof_pathIndices_1)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_2 = poseidons_out) ->
  ((inclusionProof_pathIndices_2 * (1%F - inclusionProof_pathIndices_2)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_2)) ->
  ((mux_c_0_1 = treeSiblings_2) /\ (mux_c_0_1 = inclusionProof_siblings_2)) ->
  ((mux_c_1_0 = treeSiblings_2) /\ (mux_c_1_0 = inclusionProof_siblings_2)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_2)) ->
  ((mux_s = treePathIndices_2) /\ (mux_s = inclusionProof_pathIndices_2)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_3 = poseidons_out) ->
  ((inclusionProof_pathIndices_3 * (1%F - inclusionProof_pathIndices_3)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_3)) ->
  ((mux_c_0_1 = treeSiblings_3) /\ (mux_c_0_1 = inclusionProof_siblings_3)) ->
  ((mux_c_1_0 = treeSiblings_3) /\ (mux_c_1_0 = inclusionProof_siblings_3)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_3)) ->
  ((mux_s = treePathIndices_3) /\ (mux_s = inclusionProof_pathIndices_3)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_4 = poseidons_out) ->
  ((inclusionProof_pathIndices_4 * (1%F - inclusionProof_pathIndices_4)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_4)) ->
  ((mux_c_0_1 = treeSiblings_4) /\ (mux_c_0_1 = inclusionProof_siblings_4)) ->
  ((mux_c_1_0 = treeSiblings_4) /\ (mux_c_1_0 = inclusionProof_siblings_4)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_4)) ->
  ((mux_s = treePathIndices_4) /\ (mux_s = inclusionProof_pathIndices_4)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_5 = poseidons_out) ->
  ((inclusionProof_pathIndices_5 * (1%F - inclusionProof_pathIndices_5)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_5)) ->
  ((mux_c_0_1 = treeSiblings_5) /\ (mux_c_0_1 = inclusionProof_siblings_5)) ->
  ((mux_c_1_0 = treeSiblings_5) /\ (mux_c_1_0 = inclusionProof_siblings_5)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_5)) ->
  ((mux_s = treePathIndices_5) /\ (mux_s = inclusionProof_pathIndices_5)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_6 = poseidons_out) ->
  ((inclusionProof_pathIndices_6 * (1%F - inclusionProof_pathIndices_6)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_6)) ->
  ((mux_c_0_1 = treeSiblings_6) /\ (mux_c_0_1 = inclusionProof_siblings_6)) ->
  ((mux_c_1_0 = treeSiblings_6) /\ (mux_c_1_0 = inclusionProof_siblings_6)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_6)) ->
  ((mux_s = treePathIndices_6) /\ (mux_s = inclusionProof_pathIndices_6)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_7 = poseidons_out) ->
  ((inclusionProof_pathIndices_7 * (1%F - inclusionProof_pathIndices_7)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_7)) ->
  ((mux_c_0_1 = treeSiblings_7) /\ (mux_c_0_1 = inclusionProof_siblings_7)) ->
  ((mux_c_1_0 = treeSiblings_7) /\ (mux_c_1_0 = inclusionProof_siblings_7)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_7)) ->
  ((mux_s = treePathIndices_7) /\ (mux_s = inclusionProof_pathIndices_7)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_8 = poseidons_out) ->
  ((inclusionProof_pathIndices_8 * (1%F - inclusionProof_pathIndices_8)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_8)) ->
  ((mux_c_0_1 = treeSiblings_8) /\ (mux_c_0_1 = inclusionProof_siblings_8)) ->
  ((mux_c_1_0 = treeSiblings_8) /\ (mux_c_1_0 = inclusionProof_siblings_8)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_8)) ->
  ((mux_s = treePathIndices_8) /\ (mux_s = inclusionProof_pathIndices_8)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_9 = poseidons_out) ->
  ((inclusionProof_pathIndices_9 * (1%F - inclusionProof_pathIndices_9)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_9)) ->
  ((mux_c_0_1 = treeSiblings_9) /\ (mux_c_0_1 = inclusionProof_siblings_9)) ->
  ((mux_c_1_0 = treeSiblings_9) /\ (mux_c_1_0 = inclusionProof_siblings_9)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_9)) ->
  ((mux_s = treePathIndices_9) /\ (mux_s = inclusionProof_pathIndices_9)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_10 = poseidons_out) ->
  ((inclusionProof_pathIndices_10 * (1%F - inclusionProof_pathIndices_10)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_10)) ->
  ((mux_c_0_1 = treeSiblings_10) /\ (mux_c_0_1 = inclusionProof_siblings_10)) ->
  ((mux_c_1_0 = treeSiblings_10) /\ (mux_c_1_0 = inclusionProof_siblings_10)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_10)) ->
  ((mux_s = treePathIndices_10) /\ (mux_s = inclusionProof_pathIndices_10)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_11 = poseidons_out) ->
  ((inclusionProof_pathIndices_11 * (1%F - inclusionProof_pathIndices_11)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_11)) ->
  ((mux_c_0_1 = treeSiblings_11) /\ (mux_c_0_1 = inclusionProof_siblings_11)) ->
  ((mux_c_1_0 = treeSiblings_11) /\ (mux_c_1_0 = inclusionProof_siblings_11)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_11)) ->
  ((mux_s = treePathIndices_11) /\ (mux_s = inclusionProof_pathIndices_11)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_12 = poseidons_out) ->
  ((inclusionProof_pathIndices_12 * (1%F - inclusionProof_pathIndices_12)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_12)) ->
  ((mux_c_0_1 = treeSiblings_12) /\ (mux_c_0_1 = inclusionProof_siblings_12)) ->
  ((mux_c_1_0 = treeSiblings_12) /\ (mux_c_1_0 = inclusionProof_siblings_12)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_12)) ->
  ((mux_s = treePathIndices_12) /\ (mux_s = inclusionProof_pathIndices_12)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_13 = poseidons_out) ->
  ((inclusionProof_pathIndices_13 * (1%F - inclusionProof_pathIndices_13)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_13)) ->
  ((mux_c_0_1 = treeSiblings_13) /\ (mux_c_0_1 = inclusionProof_siblings_13)) ->
  ((mux_c_1_0 = treeSiblings_13) /\ (mux_c_1_0 = inclusionProof_siblings_13)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_13)) ->
  ((mux_s = treePathIndices_13) /\ (mux_s = inclusionProof_pathIndices_13)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_14 = poseidons_out) ->
  ((inclusionProof_pathIndices_14 * (1%F - inclusionProof_pathIndices_14)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_14)) ->
  ((mux_c_0_1 = treeSiblings_14) /\ (mux_c_0_1 = inclusionProof_siblings_14)) ->
  ((mux_c_1_0 = treeSiblings_14) /\ (mux_c_1_0 = inclusionProof_siblings_14)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_14)) ->
  ((mux_s = treePathIndices_14) /\ (mux_s = inclusionProof_pathIndices_14)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_15 = poseidons_out) ->
  ((inclusionProof_pathIndices_15 * (1%F - inclusionProof_pathIndices_15)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_15)) ->
  ((mux_c_0_1 = treeSiblings_15) /\ (mux_c_0_1 = inclusionProof_siblings_15)) ->
  ((mux_c_1_0 = treeSiblings_15) /\ (mux_c_1_0 = inclusionProof_siblings_15)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_15)) ->
  ((mux_s = treePathIndices_15) /\ (mux_s = inclusionProof_pathIndices_15)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_16 = poseidons_out) ->
  ((inclusionProof_pathIndices_16 * (1%F - inclusionProof_pathIndices_16)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_16)) ->
  ((mux_c_0_1 = treeSiblings_16) /\ (mux_c_0_1 = inclusionProof_siblings_16)) ->
  ((mux_c_1_0 = treeSiblings_16) /\ (mux_c_1_0 = inclusionProof_siblings_16)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_16)) ->
  ((mux_s = treePathIndices_16) /\ (mux_s = inclusionProof_pathIndices_16)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_17 = poseidons_out) ->
  ((inclusionProof_pathIndices_17 * (1%F - inclusionProof_pathIndices_17)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_17)) ->
  ((mux_c_0_1 = treeSiblings_17) /\ (mux_c_0_1 = inclusionProof_siblings_17)) ->
  ((mux_c_1_0 = treeSiblings_17) /\ (mux_c_1_0 = inclusionProof_siblings_17)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_17)) ->
  ((mux_s = treePathIndices_17) /\ (mux_s = inclusionProof_pathIndices_17)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_18 = poseidons_out) ->
  ((inclusionProof_pathIndices_18 * (1%F - inclusionProof_pathIndices_18)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_18)) ->
  ((mux_c_0_1 = treeSiblings_18) /\ (mux_c_0_1 = inclusionProof_siblings_18)) ->
  ((mux_c_1_0 = treeSiblings_18) /\ (mux_c_1_0 = inclusionProof_siblings_18)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_18)) ->
  ((mux_s = treePathIndices_18) /\ (mux_s = inclusionProof_pathIndices_18)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_19 = poseidons_out) ->
  ((inclusionProof_pathIndices_19 * (1%F - inclusionProof_pathIndices_19)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_19)) ->
  ((mux_c_0_1 = treeSiblings_19) /\ (mux_c_0_1 = inclusionProof_siblings_19)) ->
  ((mux_c_1_0 = treeSiblings_19) /\ (mux_c_1_0 = inclusionProof_siblings_19)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_19)) ->
  ((mux_s = treePathIndices_19) /\ (mux_s = inclusionProof_pathIndices_19)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_20 = poseidons_out) ->
  ((inclusionProof_root = poseidons_out) /\ (inclusionProof_root = inclusionProof_hashes_20)) ->
  (((root = poseidons_out) /\ (root = inclusionProof_hashes_20)) /\ (root = inclusionProof_root)) ->
  (signalHashSquared = (signalHash * signalHash)%F) ->
  ((nullifierHash = poseidon_out) /\ (nullifierHash = calculateNullifierHash_out)) ->
  (((((v = poseidons_out) /\ (v = inclusionProof_hashes_20)) /\ (v = inclusionProof_root)) /\ (v = root)) ->
  (v = (MerkleTreeInclusionProof (CalculateIdentityCommitment (CalculateSecret identityNullifier identityTrapdoor))
  (treePathIndices_0 :: (treePathIndices_1 :: (treePathIndices_2 :: (treePathIndices_3 :: (treePathIndices_4 :: (treePathIndices_5 :: (treePathIndices_6 :: (treePathIndices_7 :: (treePathIndices_8 :: (treePathIndices_9 :: (treePathIndices_10 :: (treePathIndices_11 :: (treePathIndices_12 :: (treePathIndices_13 :: (treePathIndices_14 :: (treePathIndices_15 :: (treePathIndices_16 :: (treePathIndices_17 :: (treePathIndices_18 :: (treePathIndices_19 :: nil))))))))))))))))))))
  (treeSiblings_0 :: (treeSiblings_1 :: (treeSiblings_2 :: (treeSiblings_3 :: (treeSiblings_4 :: (treeSiblings_5 :: (treeSiblings_6 :: (treeSiblings_7 :: (treeSiblings_8 :: (treeSiblings_9 :: (treeSiblings_10 :: (treeSiblings_11 :: (treeSiblings_12 :: (treeSiblings_13 :: (treeSiblings_14 :: (treeSiblings_15 :: (treeSiblings_16 :: (treeSiblings_17 :: (treeSiblings_18 :: (treeSiblings_19 :: nil))))))))))))))))))))))).
Proof. Admitted.

Lemma Semaphore_obligation323: forall (signalHash : F)
  (externalNullifier : F)
  (identityNullifier : F)
  (identityTrapdoor : F)
  (treePathIndices_0 : F)
  (treePathIndices_1 : F)
  (treePathIndices_2 : F)
  (treePathIndices_3 : F)
  (treePathIndices_4 : F)
  (treePathIndices_5 : F)
  (treePathIndices_6 : F)
  (treePathIndices_7 : F)
  (treePathIndices_8 : F)
  (treePathIndices_9 : F)
  (treePathIndices_10 : F)
  (treePathIndices_11 : F)
  (treePathIndices_12 : F)
  (treePathIndices_13 : F)
  (treePathIndices_14 : F)
  (treePathIndices_15 : F)
  (treePathIndices_16 : F)
  (treePathIndices_17 : F)
  (treePathIndices_18 : F)
  (treePathIndices_19 : F)
  (treeSiblings_0 : F)
  (treeSiblings_1 : F)
  (treeSiblings_2 : F)
  (treeSiblings_3 : F)
  (treeSiblings_4 : F)
  (treeSiblings_5 : F)
  (treeSiblings_6 : F)
  (treeSiblings_7 : F)
  (treeSiblings_8 : F)
  (treeSiblings_9 : F)
  (treeSiblings_10 : F)
  (treeSiblings_11 : F)
  (treeSiblings_12 : F)
  (treeSiblings_13 : F)
  (treeSiblings_14 : F)
  (treeSiblings_15 : F)
  (treeSiblings_16 : F)
  (treeSiblings_17 : F)
  (treeSiblings_18 : F)
  (treeSiblings_19 : F)
  (calculateSecret_identityNullifier : F)
  (calculateSecret_identityTrapdoor : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (poseidon_out : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (calculateSecret_out : F)
  (secret : F)
  (calculateIdentityCommitment_secret : F)
  (poseidon_inputs_0 : F)
  (poseidon_out : F)
  (poseidon_inputs_1 : F)
  (poseidon_inputs_0 : F)
  (calculateIdentityCommitment_out : F)
  (calculateNullifierHash_externalNullifier : F)
  (calculateNullifierHash_identityNullifier : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (poseidon_out : F)
  (poseidon_inputs_0 : F)
  (poseidon_inputs_1 : F)
  (calculateNullifierHash_out : F)
  (inclusionProof_leaf : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_pathIndices_0 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_pathIndices_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_pathIndices_2 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_pathIndices_3 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_pathIndices_4 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_pathIndices_5 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_pathIndices_6 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_pathIndices_7 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_pathIndices_8 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_pathIndices_9 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_pathIndices_10 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_pathIndices_11 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_pathIndices_12 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_pathIndices_13 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_pathIndices_14 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_pathIndices_15 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_pathIndices_16 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_pathIndices_17 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_pathIndices_18 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_hashes_0 : F)
  (_assertion_1 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_1 : F)
  (_assertion_2 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_2 : F)
  (_assertion_3 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_3 : F)
  (_assertion_4 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_4 : F)
  (_assertion_5 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_5 : F)
  (_assertion_6 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_6 : F)
  (_assertion_7 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_7 : F)
  (_assertion_8 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_8 : F)
  (_assertion_9 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_9 : F)
  (_assertion_10 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_10 : F)
  (_assertion_11 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_11 : F)
  (_assertion_12 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_12 : F)
  (_assertion_13 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_13 : F)
  (_assertion_14 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_14 : F)
  (_assertion_15 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_15 : F)
  (_assertion_16 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_16 : F)
  (_assertion_17 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_17 : F)
  (_assertion_18 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_18 : F)
  (_assertion_19 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_19 : F)
  (_assertion_20 : unit)
  (mux_c_0_0 : F)
  (mux_c_0_1 : F)
  (mux_c_1_0 : F)
  (mux_c_1_1 : F)
  (mux_s : F)
  (mux_out_0 : F)
  (mux_out_1 : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (poseidons_out : F)
  (poseidons_inputs_0 : F)
  (poseidons_inputs_1 : F)
  (inclusionProof_hashes_20 : F)
  (inclusionProof_root : F)
  (root : F)
  (signalHashSquared : F)
  (nullifierHash : F)
  (v : F), (calculateSecret_identityNullifier = identityNullifier) ->
  (calculateSecret_identityTrapdoor = identityTrapdoor) ->
  ((poseidon_inputs_0 = identityNullifier) /\ (poseidon_inputs_0 = calculateSecret_identityNullifier)) ->
  ((poseidon_inputs_1 = identityTrapdoor) /\ (poseidon_inputs_1 = calculateSecret_identityTrapdoor)) ->
  (calculateSecret_out = poseidon_out) ->
  ((secret = poseidon_out) /\ (secret = calculateSecret_out)) ->
  (((calculateIdentityCommitment_secret = poseidon_out) /\ (calculateIdentityCommitment_secret = calculateSecret_out)) /\ (calculateIdentityCommitment_secret = secret)) ->
  ((((poseidon_inputs_0 = poseidon_out) /\ (poseidon_inputs_0 = calculateSecret_out)) /\ (poseidon_inputs_0 = secret)) /\ (poseidon_inputs_0 = calculateIdentityCommitment_secret)) ->
  (calculateIdentityCommitment_out = poseidon_out) ->
  (calculateNullifierHash_externalNullifier = externalNullifier) ->
  (calculateNullifierHash_identityNullifier = identityNullifier) ->
  ((poseidon_inputs_0 = externalNullifier) /\ (poseidon_inputs_0 = calculateNullifierHash_externalNullifier)) ->
  ((poseidon_inputs_1 = identityNullifier) /\ (poseidon_inputs_1 = calculateNullifierHash_identityNullifier)) ->
  (calculateNullifierHash_out = poseidon_out) ->
  ((inclusionProof_leaf = poseidon_out) /\ (inclusionProof_leaf = calculateIdentityCommitment_out)) ->
  (inclusionProof_siblings_0 = treeSiblings_0) ->
  (inclusionProof_pathIndices_0 = treePathIndices_0) ->
  (inclusionProof_siblings_1 = treeSiblings_1) ->
  (inclusionProof_pathIndices_1 = treePathIndices_1) ->
  (inclusionProof_siblings_2 = treeSiblings_2) ->
  (inclusionProof_pathIndices_2 = treePathIndices_2) ->
  (inclusionProof_siblings_3 = treeSiblings_3) ->
  (inclusionProof_pathIndices_3 = treePathIndices_3) ->
  (inclusionProof_siblings_4 = treeSiblings_4) ->
  (inclusionProof_pathIndices_4 = treePathIndices_4) ->
  (inclusionProof_siblings_5 = treeSiblings_5) ->
  (inclusionProof_pathIndices_5 = treePathIndices_5) ->
  (inclusionProof_siblings_6 = treeSiblings_6) ->
  (inclusionProof_pathIndices_6 = treePathIndices_6) ->
  (inclusionProof_siblings_7 = treeSiblings_7) ->
  (inclusionProof_pathIndices_7 = treePathIndices_7) ->
  (inclusionProof_siblings_8 = treeSiblings_8) ->
  (inclusionProof_pathIndices_8 = treePathIndices_8) ->
  (inclusionProof_siblings_9 = treeSiblings_9) ->
  (inclusionProof_pathIndices_9 = treePathIndices_9) ->
  (inclusionProof_siblings_10 = treeSiblings_10) ->
  (inclusionProof_pathIndices_10 = treePathIndices_10) ->
  (inclusionProof_siblings_11 = treeSiblings_11) ->
  (inclusionProof_pathIndices_11 = treePathIndices_11) ->
  (inclusionProof_siblings_12 = treeSiblings_12) ->
  (inclusionProof_pathIndices_12 = treePathIndices_12) ->
  (inclusionProof_siblings_13 = treeSiblings_13) ->
  (inclusionProof_pathIndices_13 = treePathIndices_13) ->
  (inclusionProof_siblings_14 = treeSiblings_14) ->
  (inclusionProof_pathIndices_14 = treePathIndices_14) ->
  (inclusionProof_siblings_15 = treeSiblings_15) ->
  (inclusionProof_pathIndices_15 = treePathIndices_15) ->
  (inclusionProof_siblings_16 = treeSiblings_16) ->
  (inclusionProof_pathIndices_16 = treePathIndices_16) ->
  (inclusionProof_siblings_17 = treeSiblings_17) ->
  (inclusionProof_pathIndices_17 = treePathIndices_17) ->
  (inclusionProof_siblings_18 = treeSiblings_18) ->
  (inclusionProof_pathIndices_18 = treePathIndices_18) ->
  (inclusionProof_siblings_19 = treeSiblings_19) ->
  (inclusionProof_pathIndices_19 = treePathIndices_19) ->
  (((inclusionProof_hashes_0 = poseidon_out) /\ (inclusionProof_hashes_0 = calculateIdentityCommitment_out)) /\ (inclusionProof_hashes_0 = inclusionProof_leaf)) ->
  ((inclusionProof_pathIndices_0 * (1%F - inclusionProof_pathIndices_0)%F)%F = 0%F) ->
  ((((mux_c_0_0 = poseidon_out) /\ (mux_c_0_0 = calculateIdentityCommitment_out)) /\ (mux_c_0_0 = inclusionProof_leaf)) /\ (mux_c_0_0 = inclusionProof_hashes_0)) ->
  ((mux_c_0_1 = treeSiblings_0) /\ (mux_c_0_1 = inclusionProof_siblings_0)) ->
  ((mux_c_1_0 = treeSiblings_0) /\ (mux_c_1_0 = inclusionProof_siblings_0)) ->
  ((((mux_c_1_1 = poseidon_out) /\ (mux_c_1_1 = calculateIdentityCommitment_out)) /\ (mux_c_1_1 = inclusionProof_leaf)) /\ (mux_c_1_1 = inclusionProof_hashes_0)) ->
  ((mux_s = treePathIndices_0) /\ (mux_s = inclusionProof_pathIndices_0)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_1 = poseidons_out) ->
  ((inclusionProof_pathIndices_1 * (1%F - inclusionProof_pathIndices_1)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_1)) ->
  ((mux_c_0_1 = treeSiblings_1) /\ (mux_c_0_1 = inclusionProof_siblings_1)) ->
  ((mux_c_1_0 = treeSiblings_1) /\ (mux_c_1_0 = inclusionProof_siblings_1)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_1)) ->
  ((mux_s = treePathIndices_1) /\ (mux_s = inclusionProof_pathIndices_1)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_2 = poseidons_out) ->
  ((inclusionProof_pathIndices_2 * (1%F - inclusionProof_pathIndices_2)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_2)) ->
  ((mux_c_0_1 = treeSiblings_2) /\ (mux_c_0_1 = inclusionProof_siblings_2)) ->
  ((mux_c_1_0 = treeSiblings_2) /\ (mux_c_1_0 = inclusionProof_siblings_2)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_2)) ->
  ((mux_s = treePathIndices_2) /\ (mux_s = inclusionProof_pathIndices_2)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_3 = poseidons_out) ->
  ((inclusionProof_pathIndices_3 * (1%F - inclusionProof_pathIndices_3)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_3)) ->
  ((mux_c_0_1 = treeSiblings_3) /\ (mux_c_0_1 = inclusionProof_siblings_3)) ->
  ((mux_c_1_0 = treeSiblings_3) /\ (mux_c_1_0 = inclusionProof_siblings_3)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_3)) ->
  ((mux_s = treePathIndices_3) /\ (mux_s = inclusionProof_pathIndices_3)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_4 = poseidons_out) ->
  ((inclusionProof_pathIndices_4 * (1%F - inclusionProof_pathIndices_4)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_4)) ->
  ((mux_c_0_1 = treeSiblings_4) /\ (mux_c_0_1 = inclusionProof_siblings_4)) ->
  ((mux_c_1_0 = treeSiblings_4) /\ (mux_c_1_0 = inclusionProof_siblings_4)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_4)) ->
  ((mux_s = treePathIndices_4) /\ (mux_s = inclusionProof_pathIndices_4)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_5 = poseidons_out) ->
  ((inclusionProof_pathIndices_5 * (1%F - inclusionProof_pathIndices_5)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_5)) ->
  ((mux_c_0_1 = treeSiblings_5) /\ (mux_c_0_1 = inclusionProof_siblings_5)) ->
  ((mux_c_1_0 = treeSiblings_5) /\ (mux_c_1_0 = inclusionProof_siblings_5)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_5)) ->
  ((mux_s = treePathIndices_5) /\ (mux_s = inclusionProof_pathIndices_5)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_6 = poseidons_out) ->
  ((inclusionProof_pathIndices_6 * (1%F - inclusionProof_pathIndices_6)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_6)) ->
  ((mux_c_0_1 = treeSiblings_6) /\ (mux_c_0_1 = inclusionProof_siblings_6)) ->
  ((mux_c_1_0 = treeSiblings_6) /\ (mux_c_1_0 = inclusionProof_siblings_6)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_6)) ->
  ((mux_s = treePathIndices_6) /\ (mux_s = inclusionProof_pathIndices_6)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_7 = poseidons_out) ->
  ((inclusionProof_pathIndices_7 * (1%F - inclusionProof_pathIndices_7)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_7)) ->
  ((mux_c_0_1 = treeSiblings_7) /\ (mux_c_0_1 = inclusionProof_siblings_7)) ->
  ((mux_c_1_0 = treeSiblings_7) /\ (mux_c_1_0 = inclusionProof_siblings_7)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_7)) ->
  ((mux_s = treePathIndices_7) /\ (mux_s = inclusionProof_pathIndices_7)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_8 = poseidons_out) ->
  ((inclusionProof_pathIndices_8 * (1%F - inclusionProof_pathIndices_8)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_8)) ->
  ((mux_c_0_1 = treeSiblings_8) /\ (mux_c_0_1 = inclusionProof_siblings_8)) ->
  ((mux_c_1_0 = treeSiblings_8) /\ (mux_c_1_0 = inclusionProof_siblings_8)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_8)) ->
  ((mux_s = treePathIndices_8) /\ (mux_s = inclusionProof_pathIndices_8)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_9 = poseidons_out) ->
  ((inclusionProof_pathIndices_9 * (1%F - inclusionProof_pathIndices_9)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_9)) ->
  ((mux_c_0_1 = treeSiblings_9) /\ (mux_c_0_1 = inclusionProof_siblings_9)) ->
  ((mux_c_1_0 = treeSiblings_9) /\ (mux_c_1_0 = inclusionProof_siblings_9)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_9)) ->
  ((mux_s = treePathIndices_9) /\ (mux_s = inclusionProof_pathIndices_9)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_10 = poseidons_out) ->
  ((inclusionProof_pathIndices_10 * (1%F - inclusionProof_pathIndices_10)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_10)) ->
  ((mux_c_0_1 = treeSiblings_10) /\ (mux_c_0_1 = inclusionProof_siblings_10)) ->
  ((mux_c_1_0 = treeSiblings_10) /\ (mux_c_1_0 = inclusionProof_siblings_10)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_10)) ->
  ((mux_s = treePathIndices_10) /\ (mux_s = inclusionProof_pathIndices_10)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_11 = poseidons_out) ->
  ((inclusionProof_pathIndices_11 * (1%F - inclusionProof_pathIndices_11)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_11)) ->
  ((mux_c_0_1 = treeSiblings_11) /\ (mux_c_0_1 = inclusionProof_siblings_11)) ->
  ((mux_c_1_0 = treeSiblings_11) /\ (mux_c_1_0 = inclusionProof_siblings_11)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_11)) ->
  ((mux_s = treePathIndices_11) /\ (mux_s = inclusionProof_pathIndices_11)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_12 = poseidons_out) ->
  ((inclusionProof_pathIndices_12 * (1%F - inclusionProof_pathIndices_12)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_12)) ->
  ((mux_c_0_1 = treeSiblings_12) /\ (mux_c_0_1 = inclusionProof_siblings_12)) ->
  ((mux_c_1_0 = treeSiblings_12) /\ (mux_c_1_0 = inclusionProof_siblings_12)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_12)) ->
  ((mux_s = treePathIndices_12) /\ (mux_s = inclusionProof_pathIndices_12)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_13 = poseidons_out) ->
  ((inclusionProof_pathIndices_13 * (1%F - inclusionProof_pathIndices_13)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_13)) ->
  ((mux_c_0_1 = treeSiblings_13) /\ (mux_c_0_1 = inclusionProof_siblings_13)) ->
  ((mux_c_1_0 = treeSiblings_13) /\ (mux_c_1_0 = inclusionProof_siblings_13)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_13)) ->
  ((mux_s = treePathIndices_13) /\ (mux_s = inclusionProof_pathIndices_13)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_14 = poseidons_out) ->
  ((inclusionProof_pathIndices_14 * (1%F - inclusionProof_pathIndices_14)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_14)) ->
  ((mux_c_0_1 = treeSiblings_14) /\ (mux_c_0_1 = inclusionProof_siblings_14)) ->
  ((mux_c_1_0 = treeSiblings_14) /\ (mux_c_1_0 = inclusionProof_siblings_14)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_14)) ->
  ((mux_s = treePathIndices_14) /\ (mux_s = inclusionProof_pathIndices_14)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_15 = poseidons_out) ->
  ((inclusionProof_pathIndices_15 * (1%F - inclusionProof_pathIndices_15)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_15)) ->
  ((mux_c_0_1 = treeSiblings_15) /\ (mux_c_0_1 = inclusionProof_siblings_15)) ->
  ((mux_c_1_0 = treeSiblings_15) /\ (mux_c_1_0 = inclusionProof_siblings_15)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_15)) ->
  ((mux_s = treePathIndices_15) /\ (mux_s = inclusionProof_pathIndices_15)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_16 = poseidons_out) ->
  ((inclusionProof_pathIndices_16 * (1%F - inclusionProof_pathIndices_16)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_16)) ->
  ((mux_c_0_1 = treeSiblings_16) /\ (mux_c_0_1 = inclusionProof_siblings_16)) ->
  ((mux_c_1_0 = treeSiblings_16) /\ (mux_c_1_0 = inclusionProof_siblings_16)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_16)) ->
  ((mux_s = treePathIndices_16) /\ (mux_s = inclusionProof_pathIndices_16)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_17 = poseidons_out) ->
  ((inclusionProof_pathIndices_17 * (1%F - inclusionProof_pathIndices_17)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_17)) ->
  ((mux_c_0_1 = treeSiblings_17) /\ (mux_c_0_1 = inclusionProof_siblings_17)) ->
  ((mux_c_1_0 = treeSiblings_17) /\ (mux_c_1_0 = inclusionProof_siblings_17)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_17)) ->
  ((mux_s = treePathIndices_17) /\ (mux_s = inclusionProof_pathIndices_17)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_18 = poseidons_out) ->
  ((inclusionProof_pathIndices_18 * (1%F - inclusionProof_pathIndices_18)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_18)) ->
  ((mux_c_0_1 = treeSiblings_18) /\ (mux_c_0_1 = inclusionProof_siblings_18)) ->
  ((mux_c_1_0 = treeSiblings_18) /\ (mux_c_1_0 = inclusionProof_siblings_18)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_18)) ->
  ((mux_s = treePathIndices_18) /\ (mux_s = inclusionProof_pathIndices_18)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_19 = poseidons_out) ->
  ((inclusionProof_pathIndices_19 * (1%F - inclusionProof_pathIndices_19)%F)%F = 0%F) ->
  ((mux_c_0_0 = poseidons_out) /\ (mux_c_0_0 = inclusionProof_hashes_19)) ->
  ((mux_c_0_1 = treeSiblings_19) /\ (mux_c_0_1 = inclusionProof_siblings_19)) ->
  ((mux_c_1_0 = treeSiblings_19) /\ (mux_c_1_0 = inclusionProof_siblings_19)) ->
  ((mux_c_1_1 = poseidons_out) /\ (mux_c_1_1 = inclusionProof_hashes_19)) ->
  ((mux_s = treePathIndices_19) /\ (mux_s = inclusionProof_pathIndices_19)) ->
  (mux_out_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) ->
  (mux_out_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) ->
  ((poseidons_inputs_0 = (((mux_c_0_1 - mux_c_0_0)%F * mux_s)%F + mux_c_0_0)%F) /\ (poseidons_inputs_0 = mux_out_0)) ->
  ((poseidons_inputs_1 = (((mux_c_1_1 - mux_c_1_0)%F * mux_s)%F + mux_c_1_0)%F) /\ (poseidons_inputs_1 = mux_out_1)) ->
  (inclusionProof_hashes_20 = poseidons_out) ->
  ((inclusionProof_root = poseidons_out) /\ (inclusionProof_root = inclusionProof_hashes_20)) ->
  (((root = poseidons_out) /\ (root = inclusionProof_hashes_20)) /\ (root = inclusionProof_root)) ->
  (signalHashSquared = (signalHash * signalHash)%F) ->
  ((nullifierHash = poseidon_out) /\ (nullifierHash = calculateNullifierHash_out)) ->
  ((((v = poseidon_out) /\ (v = calculateNullifierHash_out)) /\ (v = nullifierHash)) ->
  (v = (CalculateNullifierHash externalNullifier identityNullifier))).
Proof. intros. subst. Admitted.

End Semaphore_new.