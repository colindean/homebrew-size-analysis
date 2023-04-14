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

## Performance notes

It takes around 80 minutes to run for me two requests at a time in order not to
trigger some kind of speed limit at my ISP level\[^not_ghcr\].

You can check the counts of urls and size files by running something like this:

```sh
fd .url data | wc -l
fd .size data | wc -l
```

If the numbers are the same, you've got the data for the current `formula.json`.

\[^not_ghcr\]: It's not ghcr.io rate-limiting me.
My gateway is working fine but my ISP drops the upstream connection.
It's probably some kind of DDOS protection at the DNS level.
See notes.txt for ways I might get around this since curl does
a DNS lookup every time it launches.
