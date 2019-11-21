open MySql
open ExampleTable

let config = {
  host="localhost";
  user="root";
  password="";
  database="test";
  port=3006;
}

let () = try
  let db  = connect config in
  query db "SELECT * FROM example;" |> List.map convert |> pp_rows;
  disconnect db
  with
  | ConnectionError msg -> print_endline msg
  | QueryError msg -> print_endline msg
