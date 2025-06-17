include "globals.mzn";

int: n_groups;                          % The number of groups.
int: n_per_group;                       % The size of each group.
int: n_rounds;                          % The number of rounds.

int: n_golfers = n_groups * n_per_group;

set of int: rounds = 1..n_rounds;
set of int: golfers = 1..n_golfers;
set of int: places = 1..n_golfers;

array [rounds, places] of var golfers: round_place_golfer;
array [golfers, golfers] of var 0..n_rounds: golfer_golfer_round;

    % Each member of each group must be distinct.
    %
constraint
    forall (r in rounds) (
        alldifferent (p in places) (round_place_golfer[r, p])
    );

    % Break some symmetry by strictly ordering each group in each round.
    %
constraint
    forall (r in rounds, p in places) (
        if p mod n_per_group != 0
        then round_place_golfer[r, p] < round_place_golfer[r, p + 1]
        else true
        endif
    );

    % Each pair can play together at most once.
    %
constraint
    forall (r in rounds, g in 0..(n_groups - 1), i, j in 1..n_per_group
            where i < j) (
        golfer_golfer_round[
            round_place_golfer[r, n_per_group * g + i],
            round_place_golfer[r, n_per_group * g + j]
        ] = r
    );

solve
    :: int_search([round_place_golfer[r, p] | r in rounds, p in places],
        first_fail, indomain_min, complete)
    satisfy;

output [
    "Social golfers:\n\n", 
    "Groups        : ", show(n_groups), "\n", 
    "No. per group : ", show(n_per_group), "\n",
    "No. of rounds : ", show(n_rounds), "\n"
] ++ [
    ( if p = 1 then "\nround " ++ show(r) ++ ":" else "" endif ) ++
    ( if p mod n_per_group = 1 then "   " else " " endif ) ++
    show_int(2, round_place_golfer[r, p]) | r in rounds, p in places
];

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%