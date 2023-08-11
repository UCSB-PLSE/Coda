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
Local Coercion Z.of_nat : nat >-> Z.

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

Lemma Semaphore_obligation2: forall (signalHash : F)
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
  (var_0 : F)
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
  (var_1 : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_pathIndices_0 : F)
  (var_1 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_pathIndices_1 : F)
  (var_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_pathIndices_2 : F)
  (var_1 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_pathIndices_3 : F)
  (var_1 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_pathIndices_4 : F)
  (var_1 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_pathIndices_5 : F)
  (var_1 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_pathIndices_6 : F)
  (var_1 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_pathIndices_7 : F)
  (var_1 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_pathIndices_8 : F)
  (var_1 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_pathIndices_9 : F)
  (var_1 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_pathIndices_10 : F)
  (var_1 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_pathIndices_11 : F)
  (var_1 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_pathIndices_12 : F)
  (var_1 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_pathIndices_13 : F)
  (var_1 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_pathIndices_14 : F)
  (var_1 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_pathIndices_15 : F)
  (var_1 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_pathIndices_16 : F)
  (var_1 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_pathIndices_17 : F)
  (var_1 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_pathIndices_18 : F)
  (var_1 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_root : F)
  (inclusionProof_leaf : F)
  (inclusionProof_pathIndices_0 : F)
  (inclusionProof_pathIndices_1 : F)
  (inclusionProof_pathIndices_2 : F)
  (inclusionProof_pathIndices_3 : F)
  (inclusionProof_pathIndices_4 : F)
  (inclusionProof_pathIndices_5 : F)
  (inclusionProof_pathIndices_6 : F)
  (inclusionProof_pathIndices_7 : F)
  (inclusionProof_pathIndices_8 : F)
  (inclusionProof_pathIndices_9 : F)
  (inclusionProof_pathIndices_10 : F)
  (inclusionProof_pathIndices_11 : F)
  (inclusionProof_pathIndices_12 : F)
  (inclusionProof_pathIndices_13 : F)
  (inclusionProof_pathIndices_14 : F)
  (inclusionProof_pathIndices_15 : F)
  (inclusionProof_pathIndices_16 : F)
  (inclusionProof_pathIndices_17 : F)
  (inclusionProof_pathIndices_18 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_hashes_0 : F)
  (inclusionProof_hashes_1 : F)
  (inclusionProof_hashes_2 : F)
  (inclusionProof_hashes_3 : F)
  (inclusionProof_hashes_4 : F)
  (inclusionProof_hashes_5 : F)
  (inclusionProof_hashes_6 : F)
  (inclusionProof_hashes_7 : F)
  (inclusionProof_hashes_8 : F)
  (inclusionProof_hashes_9 : F)
  (inclusionProof_hashes_10 : F)
  (inclusionProof_hashes_11 : F)
  (inclusionProof_hashes_12 : F)
  (inclusionProof_hashes_13 : F)
  (inclusionProof_hashes_14 : F)
  (inclusionProof_hashes_15 : F)
  (inclusionProof_hashes_16 : F)
  (inclusionProof_hashes_17 : F)
  (inclusionProof_hashes_18 : F)
  (inclusionProof_hashes_19 : F)
  (inclusionProof_hashes_20 : F)
  (var_1 : F)
  (root : F)
  (signalHashSquared : F)
  (nullifierHash : F)
  (v : F), (var_0 = (F.of_nat q 20)) ->
  (calculateSecret_identityNullifier = identityNullifier) ->
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
  (var_1 = 0%F) ->
  (inclusionProof_siblings_0 = treeSiblings_0) ->
  (inclusionProof_pathIndices_0 = treePathIndices_0) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_1 = treeSiblings_1) ->
  (inclusionProof_pathIndices_1 = treePathIndices_1) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_2 = treeSiblings_2) ->
  (inclusionProof_pathIndices_2 = treePathIndices_2) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_3 = treeSiblings_3) ->
  (inclusionProof_pathIndices_3 = treePathIndices_3) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_4 = treeSiblings_4) ->
  (inclusionProof_pathIndices_4 = treePathIndices_4) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_5 = treeSiblings_5) ->
  (inclusionProof_pathIndices_5 = treePathIndices_5) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_6 = treeSiblings_6) ->
  (inclusionProof_pathIndices_6 = treePathIndices_6) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_7 = treeSiblings_7) ->
  (inclusionProof_pathIndices_7 = treePathIndices_7) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_8 = treeSiblings_8) ->
  (inclusionProof_pathIndices_8 = treePathIndices_8) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_9 = treeSiblings_9) ->
  (inclusionProof_pathIndices_9 = treePathIndices_9) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_10 = treeSiblings_10) ->
  (inclusionProof_pathIndices_10 = treePathIndices_10) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_11 = treeSiblings_11) ->
  (inclusionProof_pathIndices_11 = treePathIndices_11) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_12 = treeSiblings_12) ->
  (inclusionProof_pathIndices_12 = treePathIndices_12) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_13 = treeSiblings_13) ->
  (inclusionProof_pathIndices_13 = treePathIndices_13) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_14 = treeSiblings_14) ->
  (inclusionProof_pathIndices_14 = treePathIndices_14) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_15 = treeSiblings_15) ->
  (inclusionProof_pathIndices_15 = treePathIndices_15) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_16 = treeSiblings_16) ->
  (inclusionProof_pathIndices_16 = treePathIndices_16) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_17 = treeSiblings_17) ->
  (inclusionProof_pathIndices_17 = treePathIndices_17) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_18 = treeSiblings_18) ->
  (inclusionProof_pathIndices_18 = treePathIndices_18) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_19 = treeSiblings_19) ->
  (inclusionProof_pathIndices_19 = treePathIndices_19) ->
  (var_1 = 0%F) ->
  (root = inclusionProof_root) ->
  (signalHashSquared = (signalHash * signalHash)%F) ->
  ((nullifierHash = poseidon_out) /\ (nullifierHash = calculateNullifierHash_out)) ->
  (
    ((v = inclusionProof_root) /\ (v = root)) ->
    (v = 
      (MerkleTreeInclusionProof 
        (
          CalculateIdentityCommitment (CalculateSecret identityNullifier identityTrapdoor)
        )
        (
          treePathIndices_0 :: (treePathIndices_1 :: (treePathIndices_2 :: (treePathIndices_3 :: (treePathIndices_4 :: (treePathIndices_5 :: (treePathIndices_6 :: (treePathIndices_7 :: (treePathIndices_8 :: (treePathIndices_9 :: (treePathIndices_10 :: (treePathIndices_11 :: (treePathIndices_12 :: (treePathIndices_13 :: (treePathIndices_14 :: (treePathIndices_15 :: (treePathIndices_16 :: (treePathIndices_17 :: (treePathIndices_18 :: (treePathIndices_19 :: nil)))))))))))))))))))
        )
        (
          treeSiblings_0 :: (treeSiblings_1 :: (treeSiblings_2 :: (treeSiblings_3 :: (treeSiblings_4 :: (treeSiblings_5 :: (treeSiblings_6 :: (treeSiblings_7 :: (treeSiblings_8 :: (treeSiblings_9 :: (treeSiblings_10 :: (treeSiblings_11 :: (treeSiblings_12 :: (treeSiblings_13 :: (treeSiblings_14 :: (treeSiblings_15 :: (treeSiblings_16 :: (treeSiblings_17 :: (treeSiblings_18 :: (treeSiblings_19 :: nil)))))))))))))))))))
        )
      )
    )
  ).
Proof. 
  intros.
Admitted.

Lemma Semaphore_obligation3: forall (signalHash : F)
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
  (var_0 : F)
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
  (var_1 : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_pathIndices_0 : F)
  (var_1 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_pathIndices_1 : F)
  (var_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_pathIndices_2 : F)
  (var_1 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_pathIndices_3 : F)
  (var_1 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_pathIndices_4 : F)
  (var_1 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_pathIndices_5 : F)
  (var_1 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_pathIndices_6 : F)
  (var_1 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_pathIndices_7 : F)
  (var_1 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_pathIndices_8 : F)
  (var_1 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_pathIndices_9 : F)
  (var_1 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_pathIndices_10 : F)
  (var_1 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_pathIndices_11 : F)
  (var_1 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_pathIndices_12 : F)
  (var_1 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_pathIndices_13 : F)
  (var_1 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_pathIndices_14 : F)
  (var_1 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_pathIndices_15 : F)
  (var_1 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_pathIndices_16 : F)
  (var_1 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_pathIndices_17 : F)
  (var_1 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_pathIndices_18 : F)
  (var_1 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_root : F)
  (inclusionProof_leaf : F)
  (inclusionProof_pathIndices_0 : F)
  (inclusionProof_pathIndices_1 : F)
  (inclusionProof_pathIndices_2 : F)
  (inclusionProof_pathIndices_3 : F)
  (inclusionProof_pathIndices_4 : F)
  (inclusionProof_pathIndices_5 : F)
  (inclusionProof_pathIndices_6 : F)
  (inclusionProof_pathIndices_7 : F)
  (inclusionProof_pathIndices_8 : F)
  (inclusionProof_pathIndices_9 : F)
  (inclusionProof_pathIndices_10 : F)
  (inclusionProof_pathIndices_11 : F)
  (inclusionProof_pathIndices_12 : F)
  (inclusionProof_pathIndices_13 : F)
  (inclusionProof_pathIndices_14 : F)
  (inclusionProof_pathIndices_15 : F)
  (inclusionProof_pathIndices_16 : F)
  (inclusionProof_pathIndices_17 : F)
  (inclusionProof_pathIndices_18 : F)
  (inclusionProof_pathIndices_19 : F)
  (inclusionProof_siblings_0 : F)
  (inclusionProof_siblings_1 : F)
  (inclusionProof_siblings_2 : F)
  (inclusionProof_siblings_3 : F)
  (inclusionProof_siblings_4 : F)
  (inclusionProof_siblings_5 : F)
  (inclusionProof_siblings_6 : F)
  (inclusionProof_siblings_7 : F)
  (inclusionProof_siblings_8 : F)
  (inclusionProof_siblings_9 : F)
  (inclusionProof_siblings_10 : F)
  (inclusionProof_siblings_11 : F)
  (inclusionProof_siblings_12 : F)
  (inclusionProof_siblings_13 : F)
  (inclusionProof_siblings_14 : F)
  (inclusionProof_siblings_15 : F)
  (inclusionProof_siblings_16 : F)
  (inclusionProof_siblings_17 : F)
  (inclusionProof_siblings_18 : F)
  (inclusionProof_siblings_19 : F)
  (inclusionProof_hashes_0 : F)
  (inclusionProof_hashes_1 : F)
  (inclusionProof_hashes_2 : F)
  (inclusionProof_hashes_3 : F)
  (inclusionProof_hashes_4 : F)
  (inclusionProof_hashes_5 : F)
  (inclusionProof_hashes_6 : F)
  (inclusionProof_hashes_7 : F)
  (inclusionProof_hashes_8 : F)
  (inclusionProof_hashes_9 : F)
  (inclusionProof_hashes_10 : F)
  (inclusionProof_hashes_11 : F)
  (inclusionProof_hashes_12 : F)
  (inclusionProof_hashes_13 : F)
  (inclusionProof_hashes_14 : F)
  (inclusionProof_hashes_15 : F)
  (inclusionProof_hashes_16 : F)
  (inclusionProof_hashes_17 : F)
  (inclusionProof_hashes_18 : F)
  (inclusionProof_hashes_19 : F)
  (inclusionProof_hashes_20 : F)
  (var_1 : F)
  (root : F)
  (signalHashSquared : F)
  (nullifierHash : F)
  (v : F), (var_0 = F.of_nat q 20) ->
  (calculateSecret_identityNullifier = identityNullifier) ->
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
  (var_1 = 0%F) ->
  (inclusionProof_siblings_0 = treeSiblings_0) ->
  (inclusionProof_pathIndices_0 = treePathIndices_0) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_1 = treeSiblings_1) ->
  (inclusionProof_pathIndices_1 = treePathIndices_1) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_2 = treeSiblings_2) ->
  (inclusionProof_pathIndices_2 = treePathIndices_2) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_3 = treeSiblings_3) ->
  (inclusionProof_pathIndices_3 = treePathIndices_3) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_4 = treeSiblings_4) ->
  (inclusionProof_pathIndices_4 = treePathIndices_4) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_5 = treeSiblings_5) ->
  (inclusionProof_pathIndices_5 = treePathIndices_5) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_6 = treeSiblings_6) ->
  (inclusionProof_pathIndices_6 = treePathIndices_6) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_7 = treeSiblings_7) ->
  (inclusionProof_pathIndices_7 = treePathIndices_7) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_8 = treeSiblings_8) ->
  (inclusionProof_pathIndices_8 = treePathIndices_8) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_9 = treeSiblings_9) ->
  (inclusionProof_pathIndices_9 = treePathIndices_9) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_10 = treeSiblings_10) ->
  (inclusionProof_pathIndices_10 = treePathIndices_10) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_11 = treeSiblings_11) ->
  (inclusionProof_pathIndices_11 = treePathIndices_11) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_12 = treeSiblings_12) ->
  (inclusionProof_pathIndices_12 = treePathIndices_12) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_13 = treeSiblings_13) ->
  (inclusionProof_pathIndices_13 = treePathIndices_13) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_14 = treeSiblings_14) ->
  (inclusionProof_pathIndices_14 = treePathIndices_14) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_15 = treeSiblings_15) ->
  (inclusionProof_pathIndices_15 = treePathIndices_15) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_16 = treeSiblings_16) ->
  (inclusionProof_pathIndices_16 = treePathIndices_16) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_17 = treeSiblings_17) ->
  (inclusionProof_pathIndices_17 = treePathIndices_17) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_18 = treeSiblings_18) ->
  (inclusionProof_pathIndices_18 = treePathIndices_18) ->
  (var_1 = 0%F) ->
  (inclusionProof_siblings_19 = treeSiblings_19) ->
  (inclusionProof_pathIndices_19 = treePathIndices_19) ->
  (var_1 = 0%F) ->
  (root = inclusionProof_root) ->
  (signalHashSquared = (signalHash * signalHash)%F) ->
  ((nullifierHash = poseidon_out) /\ (nullifierHash = calculateNullifierHash_out)) ->
  (
    (((v = poseidon_out) /\ (v = calculateNullifierHash_out)) /\ (v = nullifierHash)) ->
    (v = (CalculateNullifierHash externalNullifier identityNullifier))
  ).
Proof. Admitted.

End Semaphore_new.