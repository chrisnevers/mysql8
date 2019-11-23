open Pancakes

type t = {
  id    : string;
  name  : string;
  age   : int;
  alive : bool;
}

let pp_row row =  String.concat ", " [
  row.id;
  row.name;
  string_of_int row.age;
  string_of_bool row.alive
]

let pp_rows rows = print_endline @@ String.concat "\n" @@ List.map pp_row rows

let convert row = {
  id    = row.(0);
  name  = row.(1);
  age   = MySql.int_of_cell row.(2);
  alive = MySql.bool_of_cell row.(3);
}
