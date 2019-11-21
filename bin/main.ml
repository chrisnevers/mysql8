open MySql

let () =
  print_endline "Running...";
  let _ = connect () in
  print_endline "Done!"
