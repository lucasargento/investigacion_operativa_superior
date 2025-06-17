include "globals.mzn";

int: n_groups;                          % The number of groups.
int: n_per_group;                       % The size of each group.
int: n_rounds;                          % The number of rounds.

int: n_golfers = n_groups * n_per_group;

set of int: groups = 1..n_groups;
set of int: group = 1..n_per_group;
set of int: rounds = 1..n_rounds;
set of int: golfers = 1..n_golfers;

array [rounds, groups, group] of var golfers: round_group_i_golfer;

    % Each member of each group must be distinct.
    %
constraint
    forall (r in rounds) (
        alldifferent (g in groups, i in group) (round_group_i_golfer[r, g, i])
    );

    % We also break some symmetry
    % here by strictly ordering each group.
    %
constraint
    forall (r in rounds, g in groups, i in group where i < n_per_group) (
        round_group_i_golfer[r, g, i] < round_group_i_golfer[r, g, i + 1]
    );

    % Each pair can play together at most once.
    %
constraint
    forall (a, b in golfers where a < b) (
        sum (r in rounds, g in groups, i, j in group where i < j) (
            bool2int(
                round_group_i_golfer[r, g, i] = a
            /\  round_group_i_golfer[r, g, j] = b
            )
        )
    <=
        1
    );

solve satisfy;

output [
    "Social golfers:\n\n", 
    "Groups        : ", show(n_groups), "\n", 
    "No. per group : ", show(n_per_group), "\n",
    "No. of rounds : ", show(n_rounds), "\n"
] ++ [
    ( if g = 1 /\ i = 1 then "\nround " ++ show(r) ++ ":" else "" endif) ++
    ( if i = 1 then "   " else " " endif) ++
    show_int(2, round_group_i_golfer[r, g, i]) 
    |  r in rounds, g in groups, i in group
];

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%