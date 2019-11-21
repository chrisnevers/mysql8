type connection
type query = string
type result = (string list) list

val connect : unit -> connection
val disconnect : connection -> unit
val query : connection -> query -> result
