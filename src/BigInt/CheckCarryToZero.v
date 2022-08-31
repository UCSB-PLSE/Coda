Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
Require Import Coq.Init.Peano.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Arith.Compare_dec.
Require Import Coq.PArith.BinPosDef.
Require Import Coq.ZArith.BinInt Coq.ZArith.ZArith Coq.ZArith.Zdiv Coq.ZArith.Znumtheory Coq.NArith.NArith. (* import Zdiv before Znumtheory *)
Require Import Coq.NArith.Nnat.
Require Import Coq.ZArith.Znat.


Require Import Crypto.Algebra.Hierarchy Crypto.Algebra.Field.
Require Import Crypto.Spec.ModularArithmetic.
Require Import Crypto.Arithmetic.ModularArithmeticTheorems Crypto.Arithmetic.PrimeFieldTheorems.

Require Import Crypto.Util.Decidable. (* Crypto.Util.Notations. *)
Require Import Coq.setoid_ring.Ring_theory Coq.setoid_ring.Field_theory Coq.setoid_ring.Field_tac.
Require Import Ring.


From Circom Require Import Circom Default Util DSL Tuple ListUtil LibTactics Simplify.
From Circom Require Import Repr ReprZ.
From Circom.CircomLib Require Import Bitify Comparators Gates.

(* Circuit:
* https://github.com/yi-sun/circom-pairing/blob/master/circuits/bigint.circom
*)

Module CheckCarryToZero.

Module B := Bitify.
Module D := DSL.
Module Cmp := Comparators.
Module RZU := ReprZUnsigned.
Module RZ := RZU.RZ.
Module R := Repr.

Import B.

Local Open Scope list_scope.
Local Open Scope Z_scope.
Local Open Scope F_scope.
Local Open Scope circom_scope.
Local Open Scope tuple_scope.

Local Coercion Z.of_nat: nat >-> Z.
Local Coercion N.of_nat: nat >-> N.

Lemma Nat_of_nat_add_1: forall (n: nat),
  (N.of_nat n + 1%N)%N = N.of_nat (n+1)%nat.
Proof. lia. Qed.

Section _CheckCarryToZero.
Context {n m k: nat}.

Local Notation "[| xs |]" := (RZ.as_le n xs).

Definition cons (_in: F^k) :=
  let EPSILON := 1%nat in
  exists
  (carry: F^k)
  (carryRangeChecks: (@Num2Bits.t (m - n)) ^ k),
  (* (carryRangeChecks: (@Num2Bits.t (m + EPSILON - n)) ^ k), *)
    D.iter (fun (i: nat) _cons => _cons /\
      (if (dec (i=0))%nat then
        _in[i] = carry[i] * 2^n
      else
        _in[i] + carry[i-1] = carry[i] * 2^n) /\
      (* carryRangeChecks[i].(Num2Bits._in) = carry[i] + 2^(m+EPSILON-n-1) *)
      carryRangeChecks[i].(Num2Bits._in) = carry[i]
      )
      (k-1) True /\
    _in[k-1] + carry[k-2] = 0.

Local Close Scope F_scope.

Record t := {
  _in: F^k;
  _cons: cons _in
}.

Local Open Scope F_scope.

Lemma pow_S: forall (i:nat),
  (2 * 2^i = 2^(i+1))%Z.
Proof.
  intros.
  rewrite Zpower_exp; lia.
Qed.

Lemma pow_sub_le: forall x (j i: Z),
  0 <= j ->
  0 <= i <= j ->
  (x <= 2^(j-i))%Z ->
  (2^i * x <= 2^j)%Z.
Proof.
  intros.
  apply Z.mul_le_mono_nonneg_l with (p:=(2^i)%Z) in H1; try nia.
  rewrite <- Zpower_exp in H1 by lia.
  replace (i + (j - i))%Z with j%Z in H1 by lia.
  lia.
Qed.

Lemma pow_sub_le_sub1: forall x (j i: Z),
  0 <= j ->
  0 <= i <= j ->
  (x <= 2^(j-i)-1)%Z ->
  (2^i * x <= 2^j - 2^i)%Z.
Proof.
  intros.
  apply Z.mul_le_mono_nonneg_l with (p:=(2^i)%Z) in H1; try nia.
  rewrite Z.mul_sub_distr_l in H1.
  rewrite <- Zpower_exp in H1 by lia.
  replace (i + (j - i))%Z with j%Z in H1 by lia.
  lia.
Qed.

Theorem soundness: forall (c: t), 
  1 <= n <= m ->
  2 <= k ->
  m < r ->
  'c.(_in) |: (m) ->
  'c.(_in) |: (n) ->
  [| 'c.(_in) |] = 0%Z.
Proof.
  unwrap_C.
  pose proof r_k as r_k.
  intros c H_n H_k H_m H_xm H_xn. destruct c as [x _cons]. destruct _cons as [carry [check [iter last] ] ]. simpl.
  simpl in *.
  rem_iter.
  pose_lengths.
  
  assert (Hnm: 0 <= 2^n <= 2^m). split. nia. apply Zpow_facts.Zpower_le_monotone; lia.
  assert (Hmr: 0 <= 2*2^m <= 2^r). split. nia. rewrite pow_S. apply Zpow_facts.Zpower_le_monotone; lia.
  assert (Hrk: 0 <= 2^r <= 2^C.k). split. nia. apply Zpow_facts.Zpower_le_monotone; lia.
  

  pose (Inv := fun (i: nat) _cons => _cons -> 
    forall (j: nat), j < i ->
    (2^(n*(j+1)) * |^'carry ! j|)%Z = [| ' x [:j+1] |] /\
    |^'carry!j| <= 2^(m-n)-1).
  assert (Hinv: Inv (k-1)%nat (D.iter f (k-1)%nat (True))).
  {
    apply D.iter_inv; unfold Inv.
    - lia.
    - intros i _cons IH Hi Hstep j Hj. subst f.
      destruct Hstep as [Hcons [Pcarry Pcheck]].
      destruct (dec (j = i)%nat). subst j.
      (* interesting case: j = i *)
      + lift_to_list.
        assert (Hcheck'': ' carry ! i | (m - n)). {
          pose proof (Num2Bits.range_check ('check!i)) as Hcheck.
          rewrite Pcheck in *.
          assert ((m - n)%nat <= C.k). lia. apply Hcheck in H. 
          assert (|^'carry!i| <= 2^(m-n)-1)%Z by (rewrite <- Nat2Z.inj_sub; lia).
          auto.
        }
        assert (Hcheck': 0 <= (2^n * |^'carry!i|)%Z <= 2^m). {
          assert (0 <= |^ ' carry ! i | ). apply F.to_Z_range; lia.
          split. nia.
          apply Z.mul_le_mono_nonneg_l with (p:=(2^n)%Z) in Hcheck''; try lia.
          rewrite Z.mul_sub_distr_l in Hcheck''.
          replace (2 ^ n * 2 ^ (m - n))%Z with (2^m)%Z in Hcheck''.
          lia.
          rewrite <- Zpower_exp; try lia. f_equal. lia.
        }
        split; try lia.
        destruct (dec (i=0)%nat).
        * subst. simplify.
          erewrite firstn_1 by lia. cbn [RZ.as_le].
          lift_to_list.
          fold_default.
          (* range check *)
          assert (Hm_n: (m - n)%nat <= C.k) by lia.
          pose proof (Num2Bits.range_check ('check!0) Hm_n) as Hcheck.
          rewrite Pcarry in *. clear Pcarry.
          simplify. unfold RZ.ToZ.to_Z.
          repeat (autorewrite with F_to_Z; simpl; try lia).
        * 
          lift_to_list.
          rewrite RZ.as_le_split_last' with (i:=i).
          unfold RZ.ToZ.to_Z.
          apply IH with (j:=(i-1)%nat) in Hcons; try lia. clear IH.
          destruct Hcons as [Hcons Hcarry_prev].
          replace ((Z.add (Z.of_nat (Init.Nat.sub i (S O))) (Zpos xH))) with (Z.of_nat i) in Hcons by lia.
          replace (i - 1 + 1)%nat with i in Hcons by lia.
          rewrite firstn_firstn. rewrite Nat.min_l; try lia.
          default_apply ltac:(rewrite firstn_nth).
          rewrite <- Hcons.
          (* range proof *)
          assert (2^n*|^'carry!i| = |^'carry!(i-1)|+|^'x!i|)%Z. {
            apply f_equal with (f:=F.to_Z) in Pcarry.
            autorewrite with F_to_Z in Pcarry; try lia;
            repeat (autorewrite with F_to_Z; simpl; try lia).
            simpl in Pcarry. nia.
            assert (0 <= |^ ' carry ! (i-1) | ). apply F.to_Z_range; lia.
            assert (0 <= |^ ' x!i | ). apply F.to_Z_range; lia.
            assert (|^'x!i | <= 2^m-1)%Z. unfold_default. apply Forall_nth; auto. lia.
            assert (|^ ' carry ! (i - 1) | <= 2^m-1). {
              etransitivity. apply Hcarry_prev.
              assert (2^(m-n)<=2^m)%Z.
              eapply Zmult_le_reg_r with (p:=(2^n)%Z). nia.
              repeat rewrite <- Zpower_exp; try lia.
              apply Zpow_facts.Zpower_le_monotone; try lia.
              lia.
            }
            lia.
          }
          replace (n * (i + 1))%Z with (n*i+n)%Z by lia.
          simplify.
          rewrite firstn_length_le; lia.
          apply Forall_firstn. auto.
      + assert (j < i)%nat by lia. apply IH. subst. intuit. lia.
  }
  specialize (Hinv iter (k-2)%nat). clear Inv iter.
  destruct Hinv as [Hinv Hcheck]; try lia.

  assert (H: (2^(n * (k-1)) * |^'carry!(k - 2)|)%Z = [|' x [:k - 2 + 1]|]). {
    replace (n * (k - 1))%Z with (n * ((k - 2)%nat + 1))%Z by nia.
    apply Hinv.
  }
  replace (k - 2 + 1)%nat with (k-1)%nat in * by lia.
  erewrite RZ.as_le_split_last' with (i:= (k-1)%nat); auto; try lia. unfold RZ.ToZ.to_Z.
  replace ((Z.of_nat (Init.Nat.sub k (S O)))) with (Z.sub (Z.of_nat k) (Zpos xH)) by lia.
  rewrite <- H.

  lift_to_list.
  assert (|^'x!(k - 1)| + |^'carry!(k - 2)| = 0)%Z. {
    apply f_equal with (f:=F.to_Z) in last.
    autorewrite with F_to_Z in last; try lia;
    repeat autorewrite with F_to_Z; try lia.
    assert (0 <= |^ ' x ! (k - 1) |). apply F.to_Z_range. lia.
    assert (0 <= |^ ' carry ! (k - 2) |). apply F.to_Z_range. lia.
    assert (|^ ' x ! (k - 1) | <= 2^m-1)%Z. unfold_default. apply Forall_nth. auto. lia.
    assert (|^ ' carry ! (k - 2) |<= 2^m-1). {
      etransitivity. apply Hcheck.
      assert (2^(m-n)<=2^m)%Z.
      eapply Zmult_le_reg_r with (p:=(2^n)%Z). nia.
      repeat rewrite <- Zpower_exp; try lia.
      apply Zpow_facts.Zpower_le_monotone; try lia.
      lia.
    }
    lia.
  }
  nia.

Unshelve. exact F.zero.
Qed.

End _CheckCarryToZero.
End CheckCarryToZero.