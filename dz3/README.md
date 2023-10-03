# dz3

High level bindings to the Z3 SMT solver.

## What is Z3?

Z3 is a state-of-the art theorem prover developed at Microsoft Research. It can be used to solve a wide variety of
constraint problems from basic satisfiability to more complex problems involving quantifiers, non-linear arithmetic,
bit-vectors, and symbolic execution.

## Features

This package provides almost everything exposed by the Z3 C API, but quite a bit has been changed to make it more
idiomatic to Dart, including:

* Exception handling
* Memory management
* Automatic context translation
* Useful getters for common types
* Class hierarchy for AST nodes
* Operator overloading

## Usage

1. Install Z3 via your package manager.
   * Windows users can install pre-built binaries from chocolatey:
     ```
     choco install z3
     ```
   * Mac users can install z3 via homebrew:
     ```
     brew install z3
     ```
   * Linux users can install z3 via most package managers:
     ```
     sudo apt install z3
     ```
2. (Optional) Build Z3 from source for debugging
   1. Clone dz3 and its submodules:
      ```
      git clone --recursive https://github.com/pingbird/dz3
      ```
   2. Build it using CMake and Ninja:
      ```
      cd dz3/z3
      mkdir cmake-build-debug
      cd cmake-build-debug
      cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug ../
      ninja libz3
      ```
      For more help on building from source see https://github.com/Z3Prover/z3/blob/master/README-CMake.md
3. Add it to your pubspec.yaml file:
   ```
   dependencies:
     dz3: ^0.1.0
   ```
4. Enjoy!

See the [dz3_example/bin](https://github.com/pingbird/dz3/tree/master/dz3_example/bin) directory for complete examples.