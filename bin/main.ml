open MySql

let () =
  print_endline "Running...";
  let db = connect () in
  let res = query db "SELECT * FROM example;" in
  List.iter (fun row ->
    print_endline @@ String.concat ", " row
  ) res;
  disconnect db;
  print_endline "Done!"
