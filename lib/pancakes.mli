module MySql : sig

(** The MySQL connection handler *)
type connection
type mysql_res

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

(** Thrown if there was an error connecting to MySQL server or the database. *)
exception ConnectionError of string

(** Thrown if there was an error executing the query. *)
exception QueryError of string

(** Creates a connection to the database with the given configuration. *)
val connect : database -> connection

(** Disconnects and destroys the connection to the database. The
    handler should not be used after calling disconnect.  *)
val disconnect : connection -> unit

(** Executes the given SQL statement. *)
val query : connection -> statement -> mysql_res

(** Executes the given statement, returning the number of affected/returned
    rows and the return set. *)
val execute : connection -> statement -> (int * result)

(** Like [execute], but ignores the number of affected rows and only
    returns the return set. *)
val execute_ : connection -> statement -> result

(** Returns the number of rows returned/affected by the last query. *)
val affected_rows : connection -> int

(** Gets the return set of the last query  *)
val results : connection -> result

val str_of_cell  : cell -> string
val int_of_cell  : cell -> int
val bool_of_cell : cell -> bool
val some_bool_of_cell : cell -> bool option
val some_int_of_cell : cell -> int option
val some_str_of_cell : cell -> string option

end
