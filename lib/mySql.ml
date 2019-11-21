type connection

type query = string

type result = (string list) list

external c_connect : unit -> connection = "caml_create_connection"
external c_close : connection -> unit   = "caml_close_connection"
external c_query : connection -> query -> int = "caml_query"
external c_get_all_results : connection -> result = "caml_get_all_results"

let connect () = c_connect ()

let disconnect db = c_close db

let query db stmt =
  let _ = c_query db stmt in
  c_get_all_results db
