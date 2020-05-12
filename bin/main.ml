
open Mysql8

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
  host    = Some "localhost";
  user    = Some "root";
  pwd     = None;
  name    = Some "iready";
  port    = Some 3006;
  socket  = None
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


let some = function
  | Some s -> s
  | None -> ""


let convert row = {
  id    = some row.(0);
  col1  = some row.(1);
  col2  = some row.(2);
  col3  = some row.(3);
  col4  = some row.(4);
  col5  = some row.(5);
  col6  = some row.(6);
}


let _ =
  let db = connect config in
  let result = exec db "SELECT * FROM irp_sba_reporting_category_x_state;" in
  let count = size result in
  print_endline @@ ml642int count;
  let results = map result ~f:convert in
  pp_rows results
