CSC344 Assignment 2 (Lisp)

Here's an abstraction of a Roman gladiator game:

There is a line-up of N gladiators.

There are SEVEN doors:

FOUR doors have hungry tigers behind them,

THREE doors have doves behind them.

Each gladiator, in turn, chooses and opens a door:

If there is a tiger behind the door, The tiger kills the gladiator, and the tiger is then put back in its cage.
Otherwise (i.e., if there is a dove), The gladiator is set free, the dove is put back in its cage, and the door to one tiger is locked (and unchoosable)

All choices are (uniform) random (so the first gladiator chooses a tiger with probability 4 / 7, etc.)
Your program has two parts

Compute and print the probablility that, for each K from 0 to N, that K gladiators remain alive after the game, where N is an input to the program/function; assume it is at most 20. Express all results as rational numbers (i.e. fractions) as well as decimal proportions.

Simulate the game 1000 times, and display the observed frequencies of each outcome.
