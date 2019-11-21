open MySql

type example_table = {
  id    : string;
  name  : string;
  age   : int;
}

let pp_row row =  String.concat ", " [row.id; row.name; string_of_int row.age]
let pp_rows rows = print_endline @@ String.concat "\n" @@ List.map pp_row rows

let () =
  let db = connect () in
  let res = query db "SELECT * FROM example;" in
  let rows = List.map (fun row -> {
    id    = cell2string row.(0);
    name  = cell2string row.(1);
    age   = cell2int row.(2)
  }) res in
  pp_rows rows;
  disconnect db
