#include <stdio.h>

#include <mysql/mysql.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/custom.h>

MYSQL db;

CAMLprim value
caml_create_connection(value v) {
  // Initialize the MYSQL client library
  if (mysql_library_init(0, NULL, NULL)) {
    fprintf(stderr, "could not initialize MYSQL client library\n");
    exit(1);
  }

  // Initialize the MYSQL structure
  mysql_init(&db);

  // Connect to the database
  if(!mysql_real_connect(&db, "localhost", "root", "", "test", 3006, NULL, 0)) {
    fprintf(stderr, "failed to connect to database.\nError: %s", mysql_error(&db));
  }

  return (value) &db;
}

CAMLprim value
caml_query(value db_v, value stmt_v) {
  MYSQL* db = (MYSQL*) db_v;
  char* stmt = String_val(stmt_v);

  int result = mysql_query(db, stmt);

  if (result != 0) {
    fprintf(stderr, "Query failed.\nError: %s\n", mysql_error(db));
    // OCaml exception
  }

  return Val_int(result);
}

CAMLprim value
caml_close_connection(value db_v) {
  MYSQL* db = (MYSQL*) db_v;

  mysql_close(db);
  mysql_library_end();
  return Val_unit;
}

CAMLprim value
caml_get_all_results(value db_v) {
  CAMLparam0();

  MYSQL* db = (MYSQL*) db_v;

  // Set up result set list, etc.
  CAMLlocal3(result_set, cons, tail);
  result_set = Val_emptylist;
  tail = result_set;

  // Get the result of the query
  MYSQL_RES* res = mysql_store_result(db);
  uint64_t res_size = mysql_num_rows(res);

  MYSQL_ROW row;
  unsigned int num_fields;
  unsigned int i;

  num_fields = mysql_num_fields(res);

  // Add all the rows to the result set
  while ((row = mysql_fetch_row(res))) {
    unsigned long *lengths;
    lengths = mysql_fetch_lengths(res);

    CAMLlocal1(row_list);

    row_list = Val_emptylist;
    for (i = num_fields; i > 0; --i) {

      // Create the element in the row list
      cons = caml_alloc(2, 0);
      Store_field(cons, 0, caml_copy_string(row[i - 1] ? row[i - 1] : "NULL"));
      Store_field(cons, 1, row_list);
      row_list = cons;

    }

    // Create the element for the result set
    cons = caml_alloc(2, 0);
    Store_field(cons, 0, row_list);
    Store_field(cons, 1, Val_emptylist);

    // Add row element to result set and update tail
    if (result_set != Val_emptylist) {
      caml_modify(&Field(tail, 1), cons);
    } else {
      result_set = cons;
    }
    tail = cons;

  }

  CAMLreturn (result_set);
}
