module MySql = struct

(* Type definitions *)
type connection
type mysql_res
type statement = string
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
external connect : database -> connection = "caml_create_connection"
external disconnect : connection -> unit   = "caml_close_connection"
external query : connection -> statement -> mysql_res = "caml_query"
external results : connection -> result = "caml_results"
external affected_rows : connection -> int = "caml_affected_rows"

(* Conversion functions *)
external c_str_of_cell  : cell -> string  = "caml_cell2string"
external c_int_of_cell  : cell -> int     = "caml_cell2int"
external c_bool_of_cell : cell -> bool    = "caml_cell2bool"
external c_some_bool_of_cell  : cell -> bool option   = "caml_cell2somebool"
external c_some_int_of_cell   : cell -> int option    = "caml_cell2someint"
external c_some_str_of_cell   : cell -> string option = "caml_cell2somestr"

(* ML functions *)
let execute db stmt =
  let _ = query db stmt in
  let affected = affected_rows db in
  let rows = results db in
  (affected, rows)

let execute_ db stmt =
  let _ = query db stmt in
  results db

let str_of_cell   = c_str_of_cell
let int_of_cell   = c_int_of_cell
let bool_of_cell  = c_bool_of_cell
let some_bool_of_cell = c_some_bool_of_cell
let some_int_of_cell  = c_some_int_of_cell
let some_str_of_cell  = c_some_str_of_cell

end
