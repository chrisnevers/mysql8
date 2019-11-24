open Pancakes.MySql
open ExampleTable

let config = {
  host="localhost";
  user="root";
  password="";
  database="test";
  port=3006;
}

let select_stmt = "SELECT * FROM example;"
let insert_stmt = "INSERT INTO example VALUES ('26c66405-433b-492d-874a-a9eddaa6126f', 'Jamila', 25, NULL);"
let delete_stmt = "DELETE FROM example WHERE name = 'Jamila'"

let () = try
  let db = connect config in
  let (num_of_rows, rows) = execute db select_stmt in
  print_endline @@ "Query returned " ^ string_of_int num_of_rows ^ " rows.";
  rows |> List.map convert |> pp_rows;
  disconnect db
  with
  | ConnectionError msg -> print_endline msg
  | QueryError msg -> print_endline msg
