# dz3

High level bindings to the Z3 SMT solver.

This package provides almost everything exposed by the Z3 C API, but quite a bit has been changed to make it more
idiomatic to Dart, including:

* Exception handling
* Memory management
* Automatic context translation
* Useful getters for common types
* Class hierarchy for AST nodes
* Operator overloading

