open Pancakes
open MySql

type t = {
  id : string;
  col1: string;
  col2: string;
  col3: string;
  col4: string;
  col5: string;
  col6: string;
}


let config = {
  host="localhost";
  user="root";
  password="";
  database="test";
  port=3006;
}


let pp i (row : t) =
  print_endline @@ string_of_int i ^ ": " ^ String.concat ", " [
    row.id;
    row.col1;
    row.col2;
    row.col3;
    row.col4;
    row.col5;
    row.col6;
  ]


let pp_rows = List.iteri pp


let convert row = {
  id = row.(0);
  col1 = row.(1);
  col2 = row.(2);
  col3 = row.(3);
  col4 = row.(4);
  col5 = row.(5);
  col6 = row.(6);
}


let convert_rows xs =
  let rec aux acc = function
  | [] -> List.rev acc
  | h :: t -> aux (convert h :: acc) t
  in
  aux [] xs


let _ =
  Gc.set { (Gc.get ()) with Gc.verbose = 1 };
  let db = connect config in
  let cnt, rows = execute db "SELECT * FROM test;" in
  print_endline @@ string_of_int cnt;
  rows |> convert_rows |> pp_rows;
  ()
