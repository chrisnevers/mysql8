# 🥞 MySQL

An OCaml wrapper for the MySQL C API (v8.0)

# Install
You can install the library with:

    dune build
    dune install

# Testing
You can run the driver executable with:

    dune exec main

## To Do
* The query functionality should return rows affected/returned.

* A separate function should be used to retrieve the rows.

* Create `some_*_of_cell` functions for nullable columns.

# Contributing

Contributions to `ocaml-mysql` are greatly appreciated! ❤️

Please try to keep its implementation unassuming and configurable. 🙂
