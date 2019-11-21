type connection
external c_connect : unit -> connection = "caml_connect_db"

let connect () = c_connect ()
