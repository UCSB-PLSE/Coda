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
Require Crypto.Algebra.Nsatz.

Require Import Circom.Tuple.
Require Import Crypto.Util.Decidable.
(* Require Import Crypto.Util.Notations. *)
Require Import Coq.setoid_ring.Ring_theory Coq.setoid_ring.Field_theory Coq.setoid_ring.Field_tac.
Require Import Circom.Circom Circom.DSL Circom.Util Circom.ListUtil.
Require Import Circom.Default.
Require Import Circom.Repr.
(* Require Import VST.zlist.Zlist. *)


(* Circuits:
 * https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom
 *)
Module ReprZ (C: CIRCOM).

Import C.
Module R := Repr C.

Local Open Scope list_scope.
Local Open Scope Z_scope.
Local Open Scope circom_scope.

Local Coercion Z.of_nat : nat >-> Z.
Local Coercion N.of_nat : nat >-> N.


(* Base 2^n representations *)
Section Base2n.

Context (to_Z: F -> Z)
  (to_Z_0: to_Z 0%F = 0)
  (to_Z_1: to_Z 1%F = 1).

Variable n: nat.

Lemma to_Z_2: @F.to_Z q 2 = 2%Z.
Proof. unwrap_C. simpl. repeat rewrite Z.mod_small; lia. Qed.

(* Little- and big-endian *)
Section Endianness.

(* interpret a list of weights as representing a little-endian base-2 number *)
Fixpoint as_le_acc (i: nat) (ws: list F) : Z :=
  match ws with
  | nil => 0
  | w::ws' => to_Z w * 2^(n * i) + as_le_acc (S i) ws'
  end.

Lemma as_le_acc_S: forall ws i,
  as_le_acc (S i) ws = 2^n * as_le_acc i ws.
Proof.
  unwrap_C. induction ws as [| w ws]; intros; cbn [as_le_acc].
  - lia.
  - rewrite IHws.
    replace (n * S i)%Z with (n * i + n)%Z by lia.
    rewrite Zpower_exp by nia.
    lia.
Qed.

Definition as_le' := as_le_acc 0%nat.

Fixpoint as_le (ws: list F) : Z :=
  match ws with
  | nil => 0
  | w::ws' => to_Z w + 2^n * (as_le ws')
  end.

Notation "[| xs |]" := (as_le xs).

Lemma as_le_as_le': forall ws,
  [| ws |] = as_le' ws.
Proof.
  unwrap_C. unfold as_le'.
  induction ws; simpl.
  - reflexivity.
  - rewrite as_le_acc_S, IHws, Z.mul_0_r, Z.pow_0_r.
    lia.
Qed.

(* repr func lemma: multi-step index change *)
(* Lemma as_le'_n: forall ws (i j: nat),
  as_le' (i+j)%nat ws = 2^i * as_le' j ws.
Proof.
  unwrap_C. induction i; intros; simpl.
  - rewrite F.pow_0_r. fqsatz.
  - rewrite as_le'_S. rewrite IHi.
    replace (N.pos (Pos.of_succ_nat i)) with (1 + N.of_nat i)%N.
    rewrite F.pow_add_r.
    rewrite F.pow_1_r.
    fqsatz.
    lia.
Qed. *)

Lemma as_le_app: forall ws1 ws2,
  [| ws1 ++ ws2 |] = [| ws1 |] + 2^(n * length ws1) * [| ws2 |].
Proof.
  unwrap_C. induction ws1; intros; cbn [as_le length app].
  - rewrite Z.mul_0_r, Z.pow_0_r. lia.
  - rewrite IHws1.
    remember (length ws1) as l.
    replace (n * S l) with (n * l + n) by lia.
    rewrite Zpower_exp by nia. lia.
Qed.

Fixpoint as_be_acc (i: nat) ws :=
  match ws with
  | nil => 0
  | w::ws' => 2^(n*i) * to_Z w + as_be_acc (i-1)%nat ws'
  end.

Definition as_be ws := as_be_acc (length ws - 1) ws.

Lemma be__rev_le: forall l,
  as_be l = as_le (rev l).
Proof.
  unwrap_C. unfold as_be.
  induction l.
  - reflexivity.
  - simpl. rewrite as_le_app. simpl.
    replace (length l - 0)%nat with (length l) by lia.
    rewrite IHl.
    rewrite rev_length.
    lia.
Qed.

Lemma rev_be__le: forall l,
  as_be (rev l) = as_le l.
Proof.
  unwrap_C. intros.
  remember (rev l) as l'.
  replace l with (rev (rev l)). rewrite be__rev_le. subst. reflexivity.
  apply rev_involutive.
Qed.

End Endianness.
    

Notation "[| xs |]" := (as_le xs).

Section Representation.

Definition in_range := (R.in_range n).

Definition repr_le x m ws :=
  length ws = m /\
  List.Forall in_range ws /\
  x = [| ws |].

Definition repr_be x m ws :=
  length ws = m /\
  List.Forall in_range ws /\
  x = as_be ws.

Lemma repr_rev: forall x m ws, repr_le x m ws <-> repr_be x m (rev ws).
Proof.
  split; intros; unfold repr_le, repr_be in *.
  - intuition.
    + rewrite rev_length. auto.
    + apply Forall_rev. auto.
    + rewrite rev_be__le. auto.
  - intuition.
    + rewrite <- rev_length. auto. 
    + rewrite <- rev_involutive. apply Forall_rev. auto.
    + rewrite <- rev_be__le. auto.
Qed.

(* repr inv: base case *)
Lemma repr_le_base: repr_le 0 0%nat nil.
Proof. unfold repr_le. intuition. Qed.

(* repr inv: invert weight list *)
Lemma repr_le_invert: forall w ws,
  repr_le (as_le (w::ws)) (S (length ws)) (w::ws) ->
  repr_le (as_le ws) (length ws) ws.
Proof.
  unfold repr_le.
  intros. intuition.
  invert H. auto.
Qed.

Lemma as_be_0: forall ws, as_be (0%F::ws) = as_be ws.
Proof. 
  intros. unfold as_be. simpl. 
  rewrite to_Z_0. 
  autorewrite with natsimplify. nia.
Qed.

Lemma repr_le_last0: forall ws x n,
  repr_le x (S n) (ws ++ 0%F :: nil) ->
  repr_le x n ws.
Proof.
  unwrap_C.
  intros. rewrite repr_rev in *. rewrite rev_unit in H.
  destruct H as [H_len [ H_bin H_le] ].
  unfold repr_be. intuition idtac.
  auto.
  invert H_bin. auto.
  rewrite <- as_be_0. auto.
Qed.

Lemma repr_le_last0': forall ws x i,
  List.nth i ws 0%F = 0%F ->
  repr_le x (S i) ws ->
  repr_le x i (firstn i ws).
Proof.
  intros.
  pose proof H0 as H_repr. unfold repr_le in H0.
  apply repr_le_last0.
  rewrite <- H.
  erewrite firstn_split_last by lia.
  auto.
Qed.

(* repr inv: trivial satisfaction *)
Lemma repr_trivial: forall ws,
  Forall in_range ws ->
  repr_le (as_le ws) (length ws) ws.
Proof.
  induction ws; unfold repr_le; intuition idtac.
Qed.

(* repr inv: any prefix of weights also satisfies the inv *)
Lemma repr_le_prefix: forall ws1 ws2 x x1 l l1 ws,
  ws = ws1 ++ ws2 ->
  x = as_le ws ->
  x1 = as_le ws1 ->
  l = length ws ->
  l1 = length ws1 ->
  repr_le x l ws ->
  repr_le x1 l1 ws1.
Proof.
  unwrap_C. unfold repr_le. 
  induction ws1; intros; subst; simpl in *; intuition.
  invert H1.
  constructor; auto.
  apply Forall_app in H5. intuition.
Qed.

Lemma repr_le_firstn: forall x x' l l' ws ws' i,
  x = as_le ws ->
  x' = as_le ws' ->
  l' = length ws' ->
  l = length ws ->
  ws' = firstn i ws ->
  repr_le x l ws ->
  repr_le x' l' ws'.
Proof.
  intros. eapply repr_le_prefix with (ws2:=skipn i ws); subst; eauto.
  rewrite firstn_skipn. auto.
Qed.

Lemma as_le_split_last : forall i x ws,
  repr_le x (S i) ws ->
  [| ws |] = [| ws[:i] |] + 2^(n*i) * to_Z (ws ! i).
Proof.
  unwrap_C.
  intros. pose proof H as H'.
  unfold repr_le in H. intuition.
  subst.
  assert (exists ws', ws = ws'). exists ws. reflexivity.
  destruct H1 as [ws' Hws]. pose proof Hws as Hws'.
  erewrite <- firstn_split_last with (l:=ws) (n:=i)(d:=0%F) in Hws; auto.
  pose proof (as_le_app (ws[:i]) (ws!i::nil)).
  rewrite firstn_length_le in H1 by lia.
  replace ([| ws ! i :: nil |]) with (to_Z (ws ! i)) in H1 by (simpl; nia).
  rewrite <- H1.
  subst.
  f_equal.
  unfold List_nth_Default. rewrite nth_default_eq. auto.
Qed.

End Representation.

End Base2n.


(* interpret a tuple of weights as representing a little-endian base-2^n number *)
Global Notation "[| xs . n |]" := (as_le n xs).
End ReprZ.