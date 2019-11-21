open MySql
open ExampleTable

let () =
  let db = connect () in
  let res = query db "SELECT * FROM example;" in
  let rows = List.map (fun row -> {
    id    = row.(0);
    name  = row.(1);
    age   = cell2int row.(2);
    alive = cell2bool row.(3);
  }) res in
  pp_rows rows;
  disconnect db
