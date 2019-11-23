# 🥞 Pancakes

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

* Handle more data types

* Create `some_*_of_cell` functions for nullable columns.

# Documentation
The [Pancakes API](https://chrisnevers.github.io/pancakes/pancakes/index.html)
The [MySQL C Connector API](https://dev.mysql.com/doc/refman/8.0/en/c-api.html)

# Contributing

Contributions to `ocaml-mysql` are greatly appreciated! ❤️

Please try to keep its implementation unassuming and configurable. 🙂
