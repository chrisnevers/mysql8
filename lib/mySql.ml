(* Type definitions *)

type connection

type query = string

type cell

type row = cell array

type result = row list

(* External C functions *)

external c_connect : unit -> connection = "caml_create_connection"
external c_close : connection -> unit   = "caml_close_connection"
external c_query : connection -> query -> int = "caml_query"
external c_get_all_results : connection -> result = "caml_get_all_results"
(* Conversion functions *)
external c_cell2string  : cell -> string  = "caml_cell2string"
external c_cell2int     : cell -> int     = "caml_cell2int"

(* ML functions *)

let connect () = c_connect ()

let disconnect db = c_close db

let query db stmt =
  let _ = c_query db stmt in
  c_get_all_results db

let cell2string col = c_cell2string col

let cell2int col = c_cell2int col
