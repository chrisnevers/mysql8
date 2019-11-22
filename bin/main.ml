open MySql
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

let () = try
  let db  = connect config in
  query db select_stmt |> List.map convert |> pp_rows;
  disconnect db
  with
  | ConnectionError msg -> print_endline msg
  | QueryError msg -> print_endline msg
