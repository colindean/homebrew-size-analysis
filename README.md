# homebrew-size-analysis

Analyzing the size of Homebrew formulae bottles

KISS, to the level of probably dumb.
Largely an experiment in Make that has some useful implications.

## Usage

```sh
make formula.json  # get the data file
make urls          # split it out
make sizes         # get the sizes
```
