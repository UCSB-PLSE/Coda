Require Import Crypto.Rewriter.PerfTesting.Core.
Global Set Printing Width 1000000.
Goal True.
  UnsaturatedSolinas.perfGallinaAxOf "2^256-2^224+2^192+2^96-1" 64 1%nat.
  exact I.
Defined.