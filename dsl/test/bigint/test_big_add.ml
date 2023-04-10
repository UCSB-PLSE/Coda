open Core
open Typecheck
open Coqgen
open Bigint
open Big_add
open Big_sub
open Big_less_than
module U = Test_utils.Utils

(* let _ = U.test mod_sum_three [Circomlib.Bitify.num2bits] *)

(* let _ = U.test_ty big_add [mod_sum_three] *)
(* let _ = U.test big_add [mod_sum_three] ~liblam:[] *)
let _ = U.test big_add_mod_p [big_add; big_lt; big_sub]
