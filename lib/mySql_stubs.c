#include <stdio.h>

#include <mysql/mysql.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/custom.h>
#include <caml/callback.h>

MYSQL db;

CAMLprim value
caml_create_connection(value v) {
  CAMLparam1(v);

  // Get the record fields for the database connection
  CAMLlocal5(host_val, user_val, password_val, database_val, port_val);
  host_val = Field(v, 0);
  user_val = Field(v, 1);
  password_val = Field(v, 2);
  database_val = Field(v, 3);
  port_val = Field(v, 4);

  char* host = String_val(host_val);
  char* user = String_val(user_val);
  char* password = String_val(password_val);
  char* database = String_val(database_val);
  int port = Int_val(port_val);

  // Initialize the MYSQL client library
  if (mysql_library_init(0, NULL, NULL)) {
    caml_raise_with_string(*caml_named_value("ConnectionError"),
      "Could not initialize the MYSQL client library");
  }

  // Initialize the MYSQL structure
  mysql_init(&db);

  // Connect to the database
  if(!mysql_real_connect(&db, host, user, password, database, port, NULL, 0)) {
    caml_raise_with_string(*caml_named_value("ConnectionError"), mysql_error(&db));
  }

  return (value) &db;
}

CAMLprim value
caml_query(value db_v, value stmt_v) {
  MYSQL* db = (MYSQL*) db_v;
  char* stmt = String_val(stmt_v);

  int result = mysql_query(db, stmt);

  if (result != 0) {
    caml_raise_with_string(*caml_named_value("QueryError"), mysql_error(db));
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

  if (res == NULL) {
    if (mysql_field_count(db) == 0) {
      // Non-SELECT statement. This case is expected.
      // Probably want to return the number of rows affected.
      CAMLreturn(Val_emptylist);
    } else {
      caml_raise_with_string(*caml_named_value("QueryError"), mysql_error(db));
    }
  }


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

    row_list = caml_alloc(num_fields, 0);

    for (i = 0; i < num_fields; ++i) {
      Store_field(row_list, i, caml_copy_string(row[i] ? row[i] : "NULL"));
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

  mysql_free_result(res);

  CAMLreturn (result_set);
}

CAMLprim value
caml_cell2string(value cell) {
  CAMLparam1(cell);
  char* c = String_val(cell);
  CAMLreturn(caml_copy_string(c));
}

CAMLprim value
caml_cell2int(value cell) {
  CAMLparam1(cell);
  char* c = String_val(cell);
  int i = atoi(c);
  CAMLreturn(Val_int(i));
}

CAMLprim value
caml_cell2bool(value cell) {
  CAMLparam1(cell);
  char* c = String_val(cell);
  int i = atoi(c);
  CAMLreturn(Val_bool(i));
}
