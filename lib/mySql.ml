(* Type definitions *)

type connection
type query  = string
type cell   = string
type row    = cell array
type result = row list

type database = {
  host: string;
  user: string;
  password: string;
  database: string;
  port: int;
}

(* Exceptions *)
exception ConnectionError of string
let _ = Callback.register_exception "ConnectionError" (ConnectionError "")
exception QueryError of string
let _ = Callback.register_exception "QueryError" (QueryError "")

(* External C functions *)
external c_connect : database -> connection = "caml_create_connection"
external c_close : connection -> unit   = "caml_close_connection"
external c_query : connection -> query -> int = "caml_query"
external c_get_all_results : connection -> result = "caml_get_all_results"
(* Conversion functions *)
external c_str_of_cell  : cell -> string  = "caml_cell2string"
external c_int_of_cell  : cell -> int     = "caml_cell2int"
external c_bool_of_cell : cell -> bool    = "caml_cell2bool"

(* ML functions *)
let connect db = c_connect db

let disconnect db = c_close db

let query db stmt =
  let _ = c_query db stmt in
  c_get_all_results db

let str_of_cell   = c_str_of_cell
let int_of_cell   = c_int_of_cell
let bool_of_cell  = c_bool_of_cell
