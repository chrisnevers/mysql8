type t = {
  id    : string;
  name  : string;
  age   : int;
  alive : bool;
}

let pp_row row =  String.concat ", " [
  row.id; row.name; string_of_int row.age; string_of_bool row.alive
]
let pp_rows rows = print_endline @@ String.concat "\n" @@ List.map pp_row rows

