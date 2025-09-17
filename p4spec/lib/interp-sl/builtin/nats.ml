open Xl
open Il.Ast
module Value = Runtime_dynamic.Value
module Dep = Runtime_testgen.Dep
open Util.Source
open Error

(* Conversion between meta-numerics and OCaml numerics *)

let bigint_of_value (value : value) : Bigint.t =
  value |> Value.get_num |> Num.to_int

let value_of_bigint (ctx : Ctx.t) (i : Bigint.t) : value =
  let value =
    let vid = Value.fresh () in
    let typ = Il.Ast.NumT `NatT in
    NumV (`Nat i) $$$ { vid; typ }
  in
  Ctx.add_node ctx value;
  value

(* dec $sum(nat* ) : nat *)

let sum (ctx : Ctx.t) (at : region) (targs : targ list)
    (values_input : value list) : value =
  Extract.zero at targs;
  let values =
    Extract.one at values_input |> Value.get_list |> List.map bigint_of_value
  in
  let sum = List.fold_left Bigint.( + ) Bigint.zero values in
  value_of_bigint ctx sum

(* dec $max(nat* ) : nat *)

let max (ctx : Ctx.t) (at : region) (targs : targ list)
    (values_input : value list) : value =
  Extract.zero at targs;
  let values =
    Extract.one at values_input |> Value.get_list |> List.map bigint_of_value
  in
  let max = List.fold_left Bigint.max Bigint.zero values in
  value_of_bigint ctx max

(* dec $min(nat* ) : nat *)

let min (ctx : Ctx.t) (at : region) (targs : targ list)
    (values_input : value list) : value =
  Extract.zero at targs;
  let values =
    Extract.one at values_input |> Value.get_list |> List.map bigint_of_value
  in
  let min = match values with
    | [] -> error at "min of empty list"
    | hd :: tl -> List.fold_left Bigint.min hd tl
  in
  value_of_bigint ctx min
