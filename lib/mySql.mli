type connection
type query = string
type cell = string
type row = cell array
type result = row list
type database = {
  host: string;
  user: string;
  password: string;
  database: string;
  port: int;
}

exception ConnectionError of string
exception QueryError of string

val connect : database -> connection
val disconnect : connection -> unit
val query : connection -> query -> result
val str_of_cell  : cell -> string
val int_of_cell  : cell -> int
val bool_of_cell : cell -> bool
