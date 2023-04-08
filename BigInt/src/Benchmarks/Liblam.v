(** * DSL benchmark: ModSumThree, BigAdd, BigAddModP *)

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

From Circom Require Import Circom Util Default Tuple ListUtil LibTactics Simplify Repr ReprZ Coda.

Local Coercion N.of_nat : nat >-> N.
Local Coercion Z.of_nat : nat >-> Z.

Local Open Scope list_scope.
Local Open Scope F_scope.
Local Open Scope Z_scope.
Local Open Scope circom_scope.
Local Open Scope tuple_scope.

Module RZU := ReprZUnsigned.
Module RZ := RZU.RZ.
Definition as_le := RZ.as_le.
Local Notation "[| xs | n ]" := (RZ.as_le n xs).
Local Notation "[| xs |]" := (Repr.as_le 1%nat xs).

#[local]Hint Extern 10 (Forall _ (firstn _ _)) => apply Forall_firstn : core.
#[local]Hint Extern 10 (Forall _ (nth_Default _ _)) => unfold_default; apply Forall_nth: core.
#[local]Hint Extern 10 => match goal with 
  [ |- context[length _] ] => rewrite_length end : core.
#[local]Hint Extern 10 (Forall _ (skipn _ _)) => apply Forall_skipn : core.
#[local]Hint Extern 10 (Forall _ (rev _)) => apply Forall_rev : core.
#[local]Hint Extern 10 (Forall _ (_ :: _)) => constructor : core.
#[local]Hint Extern 10 (Z.of_N (N.of_nat _)) => rewrite nat_N_Z : core.
#[local]Hint Extern 10  => repeat match goal with
  [ H: context[Z.of_N (N.of_nat _)] |- _] => rewrite nat_N_Z in H end : core.
#[local]Hint Extern 10 (_ < _) => lia : core.
#[local]Hint Extern 10 (_ < _)%nat => lia : core.
#[local]Hint Extern 10 (_ <= _) => lia : core.
#[local]Hint Extern 10 (_ <= _)%nat => lia : core.
#[local]Hint Extern 10 (_ > _) => lia : core.
#[local]Hint Extern 10 (_ > _)%nat => lia : core.
#[local]Hint Extern 10 (_ >= _) => lia : core. 
#[local]Hint Extern 10 (_ >= _)%nat => lia : core. 
#[local]Hint Extern 10 (S _ = S _) => f_equal : core. 
#[local]Hint Extern 10 => match goal with [ |- context[List.length (_ ++ _)]] =>  rewrite app_length end : core. 



Lemma gen_rng_obligation0_trivial: forall (v : Z), True -> (((0%nat <= v) /\ (v < C.q)) -> ((0%nat <= v) /\ (v < C.q))).
Proof. intuit. Qed.

Lemma gen_rng_obligation1_trivial: forall (k : nat) (v : Z), (k < C.q) -> True -> ((v = 0%nat) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation2_trivial: forall (k : nat) (v : Z), (k < C.q) -> True -> (((v = k) /\ True) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation3_trivial: forall (k : nat) (v : Z), (k < C.q) -> True -> (((0%nat <= v) /\ (v < k)) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation4_trivial: forall (k : nat) (i : nat) (v : F), (k < C.q) -> (i < k) -> True -> (((^ v) = i) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation5_trivial: forall (k : nat) (i : nat) (v : (list F)), (k < C.q) -> (i < k) -> Forall (fun x1 => True) v -> True -> (((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (v!rng_j)) = rng_j)) /\ ((length v) = i)) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation6_trivial: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))) (v : F), (k < C.q) -> (i < k) -> match f_x with (x3,x4) => ((^ x3) = i) end -> match f_x with (x3,x4) => Forall (fun x2 => True) x4 end -> match f_x with (x3,x4) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x4!rng_j)) = rng_j)) /\ ((length x4) = i)) end -> match f_x with (x3,x4) => True end -> Forall (fun x5 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x7,x8) => True end -> match _u0 with (x7,x8) => Forall (fun x6 => True) x8 end -> match _u0 with (x7,x8) => True end -> match _u0 with (x7,x8) => ((f_x = f_x) /\ True) end -> True -> (((v = f) /\ True) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation7_trivial: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))) (v : F), (k < C.q) -> (i < k) -> match f_x with (x10,x11) => ((^ x10) = i) end -> match f_x with (x10,x11) => Forall (fun x9 => True) x11 end -> match f_x with (x10,x11) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x11!rng_j)) = rng_j)) /\ ((length x11) = i)) end -> match f_x with (x10,x11) => True end -> Forall (fun x12 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x14,x15) => True end -> match _u0 with (x14,x15) => Forall (fun x13 => True) x15 end -> match _u0 with (x14,x15) => True end -> match _u0 with (x14,x15) => ((f_x = f_x) /\ True) end -> True -> ((v = 1%F) -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation8: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))) (v : F), (k < C.q) -> (i < k) -> match f_x with (x17,x18) => ((^ x17) = i) end -> match f_x with (x17,x18) => Forall (fun x16 => True) x18 end -> match f_x with (x17,x18) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x18!rng_j)) = rng_j)) /\ ((length x18) = i)) end -> match f_x with (x17,x18) => True end -> Forall (fun x19 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x21,x22) => True end -> match _u0 with (x21,x22) => Forall (fun x20 => True) x22 end -> match _u0 with (x21,x22) => True end -> match _u0 with (x21,x22) => ((f_x = f_x) /\ True) end -> True -> ((v = (f + 1%F)%F) -> ((^ v) = (i + 1%nat)%nat)).
Proof. 
  unwrap_C.
  intros. 
  destruct f_x as [f' x']. simpl in *. subst x' f'.
  replace (Z.of_N (N.of_nat (Init.Nat.add i (S O)))) with (i+1)%Z by lia.
  subst v.
  rewrite <- H1.
  autorewrite with F_to_Z; try lia.
Qed.

Lemma gen_rng_obligation9: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))) (v : (list F)), (k < C.q) -> (i < k) -> match f_x with (x24,x25) => ((^ x24) = i) end -> match f_x with (x24,x25) => Forall (fun x23 => True) x25 end -> match f_x with (x24,x25) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x25!rng_j)) = rng_j)) /\ ((length x25) = i)) end -> match f_x with (x24,x25) => True end -> Forall (fun x26 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x28,x29) => True end -> match _u0 with (x28,x29) => Forall (fun x27 => True) x29 end -> match _u0 with (x28,x29) => True end -> match _u0 with (x28,x29) => ((f_x = f_x) /\ True) end -> Forall (fun x30 => True) v -> True -> (((v = (x ++ (f :: nil))) /\ ((length v) = ((length x) + (length (f :: nil)))%nat)) -> ((forall (rng_j:nat), 0%nat <= rng_j < (i + 1%nat)%nat -> ((^ (v!rng_j)) = rng_j)) /\ ((length v) = (i + 1%nat)%nat))).
Proof. intros. destruct f_x as [f' x']. simpl in *; intuit; subst v f' x'; auto.
destruct (dec (rng_j < i)); unfold_default.
rewrite app_nth1 by lia. fold_default. auto.
assert (rng_j=i) by lia. subst rng_j.
rewrite app_nth2 by lia. subst i. simplify. simpl. auto.
Qed.

Lemma gen_rng_obligation10_trivial: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))) (v : F), (k < C.q) -> (i < k) -> match f_x with (x32,x33) => ((^ x32) = i) end -> match f_x with (x32,x33) => Forall (fun x31 => True) x33 end -> match f_x with (x32,x33) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x33!rng_j)) = rng_j)) /\ ((length x33) = i)) end -> match f_x with (x32,x33) => True end -> Forall (fun x34 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x36,x37) => True end -> match _u0 with (x36,x37) => Forall (fun x35 => True) x37 end -> match _u0 with (x36,x37) => True end -> match _u0 with (x36,x37) => ((f_x = f_x) /\ True) end -> True -> (True -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation11_trivial: forall (k : nat) (i : nat) (f_x : (F * (list F))) (x : (list F)) (f : F) (_u0 : (F * (list F))), (k < C.q) -> (i < k) -> match f_x with (x39,x40) => ((^ x39) = i) end -> match f_x with (x39,x40) => Forall (fun x38 => True) x40 end -> match f_x with (x39,x40) => ((forall (rng_j:nat), 0%nat <= rng_j < i -> ((^ (x40!rng_j)) = rng_j)) /\ ((length x40) = i)) end -> match f_x with (x39,x40) => True end -> Forall (fun x41 => True) x -> (x = (snd f_x)) -> (f = (fst f_x)) -> match _u0 with (x43,x44) => True end -> match _u0 with (x43,x44) => Forall (fun x42 => True) x44 end -> match _u0 with (x43,x44) => True end -> match _u0 with (x43,x44) => ((f_x = f_x) /\ True) end -> (True -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation12: forall (k : nat) (v : F), (k < C.q) -> True -> ((v = 0%F) -> ((^ v) = 0%nat)).
Proof. unwrap_C. intros. subst v. autorewrite with F_to_Z. lia. Qed.

Lemma gen_rng_obligation13: forall (k : nat) (v : (list F)), (k < C.q) -> Forall (fun x45 => True) v -> True -> ((v = nil) -> ((forall (rng_j:nat), 0%nat <= rng_j < 0%nat -> ((^ (v!rng_j)) = rng_j)) /\ ((length v) = 0%nat))).
Proof. intros. subst v. intuit. lia. Qed.

Lemma gen_rng_obligation14_trivial: forall (k : nat) (v : F), (k < C.q) -> True -> (True -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation15_trivial: forall (k : nat), (k < C.q) -> (True -> True).
Proof. intuit. Qed.

Lemma gen_rng_obligation17_trivial: forall (k : nat) (_f_ks : (F * (list F))) (ks : (list F)) (_f : F) (_u1 : (F * (list F))) (v : F), (k < C.q) -> match _f_ks with (x56,x57) => ((^ x56) = k) end -> match _f_ks with (x56,x57) => Forall (fun x55 => True) x57 end -> match _f_ks with (x56,x57) => ((forall (rng_j:nat), 0%nat <= rng_j < k -> ((^ (x57!rng_j)) = rng_j)) /\ ((length x57) = k)) end -> match _f_ks with (x56,x57) => True end -> Forall (fun x58 => True) ks -> (ks = (snd _f_ks)) -> (_f = (fst _f_ks)) -> match _u1 with (x60,x61) => True end -> match _u1 with (x60,x61) => Forall (fun x59 => True) x61 end -> match _u1 with (x60,x61) => True end -> match _u1 with (x60,x61) => ((_f_ks = _f_ks) /\ True) end -> True -> (True -> True).
Proof. intros. destruct _f_ks as [_f' _ks']. simpl in *. subst _f' _ks'. intuit. Qed.