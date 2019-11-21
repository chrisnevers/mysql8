#include <stdio.h>

#include <mysql/mysql.h>
#include <caml/mlvalues.h>

MYSQL db;

CAMLprim value
caml_connect_db(value v) {
  printf("connecting to db!\n");

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
