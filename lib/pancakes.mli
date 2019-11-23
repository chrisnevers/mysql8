module MySql : sig

(** The MySQL connection handler *)
type connection

(** A SQL statement  *)
type statement = string

(** Cells are returned as strings by default  *)
type cell = string

(** Representation of one row of data *)
type row = cell array

(** The result of a query that returns rows *)
type result = row list

(** MySQL connection configuration *)
type database = {
  host: string;
  user: string;
  password: string;
  database: string;
  port: int;
}

(** Thrown if there was an error connecting to MySQL server or the database *)
exception ConnectionError of string

(** Thrown if there was an error executing the query *)
exception QueryError of string

(** Creates a connection to the database with the given configuration *)
val connect : database -> connection

(** Disconnects and destroys the connection to the database. The
    handler should not be used after calling disconnect.  *)
val disconnect : connection -> unit

(** Executes the given statement, returning the resulting rows.
    The resulting cells are all strings by default, but can be
    converted to different datatypes by using the appropriate functions. *)
val execute : connection -> statement -> result

val str_of_cell  : cell -> string
val int_of_cell  : cell -> int
val bool_of_cell : cell -> bool

end
